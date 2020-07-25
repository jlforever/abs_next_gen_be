require 'resque/tasks'

task 'resque:setup' => :environment do
  Resque.before_fork = proc { ActiveRecord::Base.connection.disconnect! }
  Resque.after_fork = proc { ActiveRecord::Base.establish_connection }
end
