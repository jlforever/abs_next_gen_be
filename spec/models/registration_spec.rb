require 'rails_helper'

describe Registration do
  describe '.of_parent_user' do
    let!(:user) { create(:user, password: 'abeiud12345!') }
    let!(:parent) { create(:parent, user: user) }
    let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
    let!(:faculty) { create(:faculty, user: faculty_user) }
    let!(:family_member1) { create(:family_member, parent: parent) }
    let!(:klass) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days) }
    let!(:registration) { create(:registration, klass: klass, primary_family_member_id: family_member1.id) }

    it 'returns back matched registrations that has the parent\'s family members enrolled' do
      result = Registration.of_parent_user(user).first
      expect(result).to eq registration
    end
  end
end
