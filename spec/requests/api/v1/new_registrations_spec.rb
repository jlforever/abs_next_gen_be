require 'rails_helper'

describe Api::V1::NewRegistrationsController, type: :request do
  include FakeAuthEstablishable

  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:credit_card) { create(:credit_card, user: user, ) }
  let!(:parent) { create(:parent, user: user) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:student2) { create(:student, first_name: 'Sammy', last_name: 'Duncan') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:family_member2) { create(:family_member, parent: parent, student: student2) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days, reg_effective_from: Time.zone.now - 3.days, reg_effective_until: Time.zone.now + 7.days) }

  before do
    establish_valid_token!(user)
  end

  describe '#create' do
    let!(:expected_amount) { CourseFeeCalculator.calculate!(class1, family_member1, family_member2) }
    let(:create_params) do
      {
        user_email: user.email,
        registration: {
          course_id: class1.id,
          charge_amount: expected_amount,
          credit_card_id: credit_card.id,
          accept_release_form: true,
          primary_family_member_id: family_member1.id,
          secondary_family_member_id: family_member2.id
        }
      }
    end

    before do
      allow(Stripe::Charge).to receive(:create).and_return({ id: 'this-is-a-successful-charge-id', outcome: {} })
      @fake_mailer = double('fake_mailer', deliver_now: nil)
      allow(RegistrationMailer).to receive(:registration_confirmation).and_return(@fake_mailer)
      allow(RegistrationMailer).to receive(:aba_admin_registration_notification).and_return(@fake_mailer)
    end

    it 'registers the course for the family members' do
      expect do
        post '/api/v1/new_registrations', params: create_params, headers: { 'Authorization' => "Bearer #{@token.access}" }
      end.to change { Registration.count }.by(1).
        and change { RegistrationCreditCardCharge.count }.by(1)

      registration = Registration.last
      registration_credit_card_charge = RegistrationCreditCardCharge.last
      expect(registration_credit_card_charge.credit_card).to eq credit_card
      expect(registration_credit_card_charge.charge_id).to eq 'this-is-a-successful-charge-id'
      expect(registration_credit_card_charge.registration).to eq registration
      expect(registration.total_due).to eq expected_amount
    end
  end
end
