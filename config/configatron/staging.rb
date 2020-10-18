configatron.redis_url = ENV['REDIS_URL']

configatron.mailer.smtp_settings.port = 587
configatron.mailer.smtp_settings.address = 'smtp.mailgun.org'
configatron.mailer.smtp_settings.user_name = ENV['MAILGUN_SMTP_LOGIN']
configatron.mailer.smtp_settings.password = ENV['MAILGUN_SMTP_PASSWORD']
configatron.mailer.smtp_settings.delivery_method = :smtp
configatron.mailer.smtp_settings.domain = 'staging.alphabetaacademy.org'

configatron.stripe.api_key = ENV['STRIPE_STG_API_KEY']
configatron.stripe.api_secret = ENV['STRIPE_STG_API_SECRET']
