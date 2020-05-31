source 'https://rubygems.org'

ruby '2.5.3'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'bcrypt'
gem 'configatron'
gem 'friendly_id', '~> 5.2.4'
gem 'jwt_sessions'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rack-cors'
gem 'rails', '~> 5.2.0'
gem 'redis', '~> 4.0'
gem 'rest-client'
gem 'swagger-docs'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'database_cleaner'
  gem 'dotenv-rails', :require => 'dotenv/rails-now'
  gem 'hirb'
  gem 'pry'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'wirble'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_bot'
  gem 'timecop'
  gem 'webmock', '1.8.11', require: false
end
