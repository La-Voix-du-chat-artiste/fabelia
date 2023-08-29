require 'replicate'

Replicate.configure do |config|
  config.api_token = ENV.fetch('REPLICATE_API_KEY', nil)
end
