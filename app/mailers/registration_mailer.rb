class RegistrationMailer < ApplicationMailer
  def test
    mail(
      :to => 'jjp4ever@gmail.com',
      :from => 'ABA <admin@alphabetaschool.org>',
      :subject => 'This is a test email',
      template_path: 'mailer/registration'
    )
  end

  def registration_confirmation(registration)
    parent_user = registration.primary_family_member.parent.user
    to_address = parent_user.email

    @parent_first_name = parent_user.first_name
    @fee = registration.total_due / 100.0
    @total_due_by = registration.total_due_by

    mail(
      to: parent_user.email,
      from: 'ABA <admin@alphabetaschool.org>',
      subject: 'Thank you for registering with ABA',
      template_path: 'mailer/registration'
    )
  end

  def aba_admin_registration_notification(registration)
    @child_first_name = registration.primary_family_member.student.first_name
    @child_last_name = registration.primary_family_member.student.last_name
    @second_child_first_name = FamilyMember.where(id: registration.secondary_family_member_id).first&.student&.first_name
    @second_child_last_name = FamilyMember.where(id: registration.secondary_family_member_id).first&.student&.last_name
    @third_child_first_name = FamilyMember.where(id: registration.tertiary_family_member_id).first&.student&.first_name
    @third_child_last_name = FamilyMember.where(id: registration.tertiary_family_member_id).first&.student&.last_name
    @parent_first_name = registration.primary_family_member.parent.user.first_name
    @parent_last_name = registration.primary_family_member.parent.user.last_name
    @studied_subject = registration.klass.specialty.subject
    @studied_level = registration.klass.specialty.category
    @parent_phone_number = registration.primary_family_member.parent.user.phone_number
    @parent_email = registration.primary_family_member.parent.user.email
    @registered_on = registration.created_at.strftime('%m-%d-%Y %H:%M:%S')

    @children_names = if @third_child_first_name.present?
      "#{@child_first_name} #{@child_last_name} and #{@second_child_first_name} #{@second_child_last_name} and #{@third_child_first_name} #{@third_child_last_name}"
    elsif @second_child_first_name.present?
      "#{@child_first_name} #{@child_last_name} and #{@second_child_first_name} #{@second_child_last_name}"
    else
      "#{@child_first_name} #{@child_last_name}"
    end

    mail(
      to: 'admin@alphabetaschool.org', 
      from: 'admin@alphabetaschool.org', 
      subject: "Kid(s): #{@children_names}, Parent: #{@parent_first_name} #{@parent_last_name} just registered for #{@studied_subject} - #{@studied_level}!",
      template_path: 'mailer/registration'
    )
  end
end
