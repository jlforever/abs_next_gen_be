configatron.redis_url = ENV['REDIS_URL']

configatron.mailer.smtp_settings.port = 587
configatron.mailer.smtp_settings.address = 'smtp.sendgrid.net'
configatron.mailer.smtp_settings.user_name = ENV['SENDGRID_USERNAME']
configatron.mailer.smtp_settings.password = ENV['SENDGRID_PASSWORD']
configatron.mailer.smtp_settings.delivery_method = :smtp
configatron.mailer.smtp_settings.domain = 'alphabetaacademy.org'

configatron.stripe.api_key = ENV['STRIPE_PROD_API_KEY']
configatron.stripe.api_secret = ENV['STRIPE_PROD_API_SECRET']
