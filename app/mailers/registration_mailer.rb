class RegistrationMailer < ApplicationMailer
  def test
    mail(
      :to => 'jjp4ever@gmail.com',
      :from => 'ABLS <admin@alphabetaschool.org>',
      :subject => 'This is a test email',
      template_path: 'mailer/registration'
    )
  end
end
