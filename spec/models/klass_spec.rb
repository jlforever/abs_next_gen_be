require 'rails_helper'

describe Klass do
  let(:testing_time) { Time.zone.local(2020, 6, 4, 10) }
  let!(:faculty_user) { create(:user, password: 'aeiou12345!') }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.local(2020, 5, 28, 10), effective_until: Time.zone.local(2020, 6, 28, 10)) }
  let!(:class2) { create(:klass, faculty: faculty, effective_from: Time.zone.local(2020, 6, 13, 10), effective_until: Time.zone.local(2020, 6, 28, 10)) }
  let!(:class3) { create(:klass, faculty: faculty, effective_from: Time.zone.local(2020, 5, 19, 10), effective_until: Time.zone.local(2020, 7, 5, 10)) }

  describe '.effective' do
    it 'only return courses that are within the effect from and until ones' do
      Timecop.freeze(testing_time) do
        results = described_class.effective
        expect(results.size).to eq 2
        expect(results).to include class1
        expect(results).to include class3
      end
    end
  end

  describe '.eligible_for_family_members' do
    let!(:parent_user) { create(:user, password: 'beije11115!') }
    let!(:parent) { create(:parent, user: parent_user)}
    let!(:student1) { create(:student, first_name: 'Hank', last_name: 'Toms') }
    let!(:student2) { create(:student, first_name: 'Sylvania', last_name: 'Toms') }
    let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
    let!(:family_member2) { create(:family_member, parent: parent, student: student2) }
    let!(:registration1) { create(:registration, klass: class1, primary_family_member: family_member1) }
    let!(:registration2) { create(:registration, klass: class3, primary_family_member: family_member1, secondary_family_member_id: family_member2.id) }
    let!(:class4) { create(:klass, faculty: faculty, effective_from: Time.zone.local(2020, 6, 2, 10), effective_until: Time.zone.local(2020, 8, 13, 10)) }

    it 'returns klass that has not been registered by any family members' do
      Timecop.freeze(testing_time) do
        results = Klass.eligible_for_family_members([family_member1, family_member2])
        expect(results.size).to eq 2
        expect(results).to include class2
        expect(results).to include class4
      end
    end
  end
end
