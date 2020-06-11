require 'rails_helper'

describe RegistrationCreator do
  let!(:user) { create(:user, password: 'abcde12345!') }
  let!(:user2) { create(:user, password: 'emmee11133!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:parent2) { create(:parent, user: user2) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days) }
  let!(:class2) { create(:klass, faculty: faculty, effective_from: Time.zone.now + 3.days, effective_until: Time.zone.now + 10.days) }
  let!(:student1) { create(:student, first_name: 'Helen', last_name: 'Downty') }
  let!(:student2) { create(:student, first_name: 'Sammy', last_name: 'Duncan') }
  let!(:student3) { create(:student, first_name: 'Marshall', last_name: 'Downty') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:family_member2) { create(:family_member, parent: parent2, student: student2) }
  let!(:family_member3) { create(:family_member, parent: parent, student: student3) }

  describe '.create!' do
    context 'when no first family members is missing' do
      it 'raises an error indicating no primary family member' do
        expect do
          described_class.create!(user, class1.id, nil, nil, nil)
        end.to raise_error(described_class::CreationError, /You cannot register without a family member/)
      end
    end

    context 'when family members do not belong to the same family' do
      it 'raises an error indicating family member do not belong together' do
        expect do
          described_class.create!(user, class1.id, family_member1, family_member2, nil)
        end.to raise_error(described_class::CreationError, /Not all of the specified family members are from the same family/)
      end
    end

    context 'when attempt to registered class is not effective' do
      it 'raises a class not found error' do
        expect do
          described_class.create!(user, class2.id, family_member1, family_member2, nil)
        end.to raise_error
      end
    end

    it 'registers a course for a given family member' do
      expect do
        described_class.create!(user, class1.id, family_member1)
      end.to change { Registration.count }.by(1)

      registration = Registration.last
      expect(registration.primary_family_member).to eq family_member1
      expect(registration.klass).to eq class1
      expect(registration.total_due).to eq 40000
    end

    it 'registers a course for a set of family members' do
      expect do
        described_class.create!(user, class1.id, family_member1, family_member3)
      end.to change { Registration.count }.by(1)
    
      registration = Registration.last
      expect(registration.primary_family_member).to eq family_member1
      expect(registration.secondary_family_member_id).to eq family_member3.id
      expect(registration.klass).to eq class1
      expect(registration.total_due).to eq 60000
    end
  end
end
