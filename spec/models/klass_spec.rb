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
end
