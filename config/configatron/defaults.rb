configatron.redis_url = 'redis://localhost:6379'

configatron.mailer.smtp_settings.address = 'localhost'
configatron.mailer.smtp_settings.port = 1025
configatron.mailer.smtp_settings.user_name = nil
configatron.mailer.smtp_settings.password = nil
configatron.mailer.smtp_settings.delivery_method = :smtp
configatron.mailer.smtp_settings.domain = 'localhost:9292'

configatron.aws.access_key = ENV['AWS_ACCESS_KEY']
configatron.aws.secret_key = ENV['AWS_SECRET_KEY']
configatron.aws.s3_bucket = ENV['AWS_S3_BUCKET']
configatron.aws.s3_region = ENV['AWS_S3_REGION']

configatron.stripe.api_key = ENV['STRIPE_API_KEY']
configatron.stripe.api_secret = ENV['STRIPE_API_SECRET']
