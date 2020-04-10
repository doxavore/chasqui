redis_url = ENV.fetch("REDIS_URL") do |key|
  if Rails.env.development? || Rails.env.test?
    "redis://localhost:6379"
  else
    raise KeyError, "Key not found: \"#{key}\""
  end
end

Resque.redis = redis_url
