RSpec.shared_examples 'a redirect response with message' do |flash_type|
  before { subject }

  it { expect(flash[flash_type]).to match message }
  it { expect(response).to have_http_status :found }
  it { expect(response).to redirect_to url_to_redirect }
end

RSpec.shared_examples 'a redirect response with success message' do
  include_examples 'a redirect response with message', :notice
end

RSpec.shared_examples 'a redirect response with alert message' do
  include_examples 'a redirect response with message', :alert
end

RSpec.shared_examples 'a user not logged in' do
  include_examples 'a redirect response with alert message', :alert do
    let(:message) { 'Vous devez être authentifié pour accéder à cette page' }
    let(:url_to_redirect) { new_sessions_path }
  end
end
