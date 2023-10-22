RSpec.configure do |config|
  config.before(:example, type: :request) do
    create(:setting) unless Setting.exists?
  end
end
