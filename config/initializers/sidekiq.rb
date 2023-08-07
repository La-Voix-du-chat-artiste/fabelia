require 'sidekiq/web'

if Rails.env.staging? || Rails.env.production?
  # @see https://github.com/mperham/sidekiq/wiki/Monitoring#rails-http-basic-auth-from-routes
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(Digest::SHA256.hexdigest(username), Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_USERNAME', nil))) &
      ActiveSupport::SecurityUtils.secure_compare(Digest::SHA256.hexdigest(password), Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_PASSWORD', nil)))
  end
end
