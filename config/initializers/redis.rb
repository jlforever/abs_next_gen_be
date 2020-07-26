$redis = Redis.new(url: configatron.redis_url)
Resque.redis = $redis
