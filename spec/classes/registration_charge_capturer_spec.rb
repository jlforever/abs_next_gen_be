require 'rails_helper'

describe RegistrationChargeCapturer do
  let(:another_user) { create(:user, password: 'dergf12345!') }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:credit_card) { create(:credit_card, user: user) }
  let!(:another_credit_card) { create(:credit_card, user: another_user) }
  let!(:parent) { create(:parent, user: user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days, reg_effective_from: Time.zone.now - 3.days, reg_effective_until: Time.zone.now + 7.days) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:registration_1) { create(:registration, status: 'pending', klass: class1, primary_family_member: family_member1) }

  before do
    @fake_mailer = double('fake_mailer', deliver_now: nil)
    allow(RegistrationMailer).to receive(:registration_with_fees_paid_confirmation).and_return(@fake_mailer)
    allow(RegistrationMailer).to receive(:aba_admin_registration_notification).and_return(@fake_mailer)
    allow(PaidClassSessionsCreateJob).to receive(:execute)
  end

  describe '.capture!' do
    it 'raises credit card not accessible error' do
      expect do
        described_class.capture!(registration_1, 1200, another_credit_card)
      end.to raise_error(described_class::CaptureError, /Unable to pay a registration with an inaccessible credit card/)
    end

    it 'captures a stripe charge and creates a registration credit card charge' do
      allow(Stripe::Charge).to receive(:create).and_return({ id: 'this-is-a-successful-charge-id', outcome: {} })
      charge = described_class.capture!(registration_1, 1200, credit_card)
      expect(Stripe::Charge).
        to have_received(:create).
        with(
          {
            amount: 1200,
            currency: 'usd',
            customer: credit_card.stripe_customer_token,
            description: an_instance_of(String)
          }
        )
      expect(charge.charge_id).to eq 'this-is-a-successful-charge-id'
      expect(charge.charge_outcome).to eq({})

      expect(charge.registration.status).to eq 'paid'
      expect(PaidClassSessionsCreateJob).to have_received(:execute).with(charge.registration)
      expect(RegistrationMailer).to have_received(:registration_with_fees_paid_confirmation).with(registration_1)
      expect(RegistrationMailer).to have_received(:aba_admin_registration_notification).with(registration_1)
    end
  end
end
