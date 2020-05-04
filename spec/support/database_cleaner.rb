require 'yaml'
require 'erb'
require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:active_record, { connection: YAML.load(ERB.new(File.read("config/database.yml")).result)['test']['database'].intern }]

    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:active_record, { connection: YAML.load(ERB.new(File.read("config/database.yml")).result)['test']['database'].intern }]

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner[:active_record, { connection: YAML.load(ERB.new(File.read("config/database.yml")).result)['test']['database'].intern }]

    DatabaseCleaner.clean
  end
end
