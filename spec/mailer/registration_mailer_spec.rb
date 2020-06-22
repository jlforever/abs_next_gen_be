require 'rails_helper'

describe RegistrationMailer do
  let!(:user) { create(:user, first_name: 'Hank', last_name: 'Zhang', password: 'abcde12345!') }
  let!(:faculty_user) { create(:user, first_name: 'JJP', last_name: 'QQ', password: 'beiou12334!') }
  let!(:parent) { create(:parent, user: user) }
  let!(:faculty) { create(:faculty, user: faculty_user) }
  let!(:class1) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 3.days, effective_until: Time.zone.now + 7.days) }
  let!(:class2) { create(:klass, faculty: faculty, effective_from: Time.zone.now - 10.days, effective_until: Time.zone.now + 20.days) }

  let!(:student1) { create(:student, first_name: 'Hank', last_name: 'Toms') }
  let!(:student2) { create(:student, first_name: 'Sylvania', last_name: 'Toms') }
  let!(:student3) { create(:student, first_name: 'George', last_name: 'Toms') }
  let!(:family_member1) { create(:family_member, parent: parent, student: student1) }
  let!(:family_member2) { create(:family_member, parent: parent, student: student2) }
  let!(:family_member3) { create(:family_member, parent: parent, student: student3) }
  let!(:registration1) { create(:registration, klass: class1, primary_family_member: family_member1, secondary_family_member_id: family_member2.id) }
  let!(:registration2) { create(:registration, klass: class2, primary_family_member: family_member1, secondary_family_member_id: family_member2.id, tertiary_family_member_id: family_member3.id) }

  describe '#registration_confirmation' do
    it 'delivers registration confirmation email to the parent user' do
      email = described_class.registration_confirmation(registration1)
      expect(email.subject).to eq 'Thank you for registering with ABA'
      expect(email.to).to match_array([user.email])
      expect(email.from).to match_array(['admin@alphabetaschool.org'])

      html_body = email.html_part.body
      text_body = email.text_part.body

      expect(html_body).to match(/Once we have received the payment and have processed the registration, we will send out a confirmation email detailing the next steps/)
      expect(text_body).to match(/Once we have received the payment and have processed the registration, we will send out a confirmation email detailing the next steps/)
    end
  end

  describe '#aba_admin_registration_notification' do
    it 'delivers registration completion, with a single child notification to ABA admin' do
      email = described_class.aba_admin_registration_notification(registration1)

      expect(email.to).to match_array(['admin@alphabetaschool.org'])
      expect(email.from).to match_array(['admin@alphabetaschool.org'])

      expect(email.subject).to eq 'Kid(s): Hank Toms and Sylvania Toms, Parent: Hank Zhang just registered for Chinese - Level 1 (4-7 years old)!'

      html_body = email.html_part.body
      text_body = email.text_part.body
      expect(html_body).to match(/A new registration has just came through. Below are the detailed info./)
      expect(text_body).to match(/A new registration has just came through. Below are the detailed info./)
    end

    it 'delivers registration completion, with multiple children notification to ABA admin' do
      email = described_class.aba_admin_registration_notification(registration2)

      expect(email.to).to match_array(['admin@alphabetaschool.org'])
      expect(email.from).to match_array(['admin@alphabetaschool.org'])

      expect(email.subject).to eq 'Kid(s): Hank Toms and Sylvania Toms and George Toms, Parent: Hank Zhang just registered for Chinese - Level 1 (4-7 years old)!'

      html_body = email.html_part.body
      text_body = email.text_part.body
      expect(html_body).to match(/A new registration has just came through. Below are the detailed info./)
      expect(text_body).to match(/A new registration has just came through. Below are the detailed info./)
    end
  end
end
