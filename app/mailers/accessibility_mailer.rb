class AccessibilityMailer < ApplicationMailer
  def request_for_password_reset(user)
    @user = user
    @host = if Rails.env.development?
      'http://localhost:8080'
    elsif Rails.env.staging?
      'https://staging.alphabetaacademy.org'
    elsif Rails.env.production?
      'https://www.alphabetaacademy.org'
    end

    mail(
      to: user.email,
      from: 'ABA <admin@alphabetaschool.org>',
      subject: 'ABA Account Password Reset',
      template_path: 'mailer/accessibility'
    )
  end
end
