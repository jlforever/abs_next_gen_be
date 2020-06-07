ActionMailer::Base.smtp_settings = {
  :address        => configatron.mailer.smtp_settings.address,
  :port           => configatron.mailer.smtp_settings.port,
  :authentication => :plain,
  :user_name      => configatron.mailer.smtp_settings.user_name,
  :password       => configatron.mailer.smtp_settings.password,
  :domain         => configatron.mailer.smtp_settings.domain,
  :enable_starttls_auto => true
}
