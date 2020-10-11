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

  describe '#first_session_date' do
    it 'identifies a datetime within effective klass range as the first session date' do
      expect(class1.first_session_date.to_date).
        to eq Time.parse('2020-06-01').to_date
    end

    context 'with klass vacay date specified' do
      let!(:vacay_date) { create(:klass_vacay_date, klass: class1, off_date: '2020-06-01') }

      it 'identifies a datetime within effective klass range and skips the vacay date, as the first session date' do
        expect(class1.first_session_date.to_date).
          to eq Time.parse('2020-06-03').to_date
      end
    end
  end

  describe '#expected_session_dates' do
    let!(:vacay_date1) { create(:klass_vacay_date, klass: class1, off_date: '2020-06-01') }
    let!(:vacay_date2) { create(:klass_vacay_date, klass: class1, off_date: '2020-06-10') }
    let!(:vacay_date3) { create(:klass_vacay_date, klass: class1, off_date: '2020-06-24') }

    it 'accumulates session dates while ignores specified vacay dates' do
      session_string_dates = class1.expected_session_dates.map { |date| date.strftime('%Y-%m-%d') }
      expect(session_string_dates).not_to include('2020-06-01')
      expect(session_string_dates).not_to include('2020-06-10')
      expect(session_string_dates).not_to include('2020-06-24')

      expect(session_string_dates).to include('2020-06-03')
      expect(session_string_dates).to include('2020-06-08')
      expect(session_string_dates).to include('2020-06-15')
      expect(session_string_dates).to include('2020-06-17')
      expect(session_string_dates).to include('2020-06-22')
    end
  end
end
