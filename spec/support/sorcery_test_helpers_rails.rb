module Sorcery
  module TestHelpers
    module Rails
      module Request
        def sign_in(user = nil, password = 'password', route = nil, http_method = :post)
          user ||= @user
          route ||= sessions_url

          username_attr = user.sorcery_config.username_attribute_names.first
          username = user.send(username_attr)
          password_attr = user.sorcery_config.password_attribute_name

          send(http_method, route, params: { session: { "#{username_attr}": username, "#{password_attr}": password } })
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Sorcery::TestHelpers::Rails::Request, type: :request

  config.before(:example, as: :logged_in, type: :request) do
    user = create :user, defined?(role) ? role : :admin
    sign_in(user)
  end
end
