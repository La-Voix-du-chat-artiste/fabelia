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

RSpec.shared_examples 'unauthorized request when logged in as standard', as: :logged_in do
  let(:role) { :standard }

  include_examples 'a redirect response with alert message', :alert do
    let(:url_to_redirect) { root_path }
    let(:message) { I18n.t('action_policy.default') }
  end
end

RSpec.shared_examples 'unauthorized request when logged in as admin', as: :logged_in do
  let(:role) { :admin }

  include_examples 'a redirect response with alert message', :alert do
    let(:url_to_redirect) { root_path }
    let(:message) { I18n.t('action_policy.default') }
  end
end

RSpec.shared_examples 'success request when logged in as standard', as: :logged_in do
  let(:role) { :standard }

  before { subject }

  it { expect(response).to have_http_status :ok }
end

RSpec.shared_examples 'success request when logged in as admin', as: :logged_in do
  let(:role) { :admin }

  before { subject }

  it { expect(response).to have_http_status :ok }
end
