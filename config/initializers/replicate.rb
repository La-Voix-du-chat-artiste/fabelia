require 'replicate'

Replicate.configure do |config|
  config.api_token = Rails.application.credentials.replicate.api_key
end
