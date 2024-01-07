require 'rails_helper'

RSpec.describe SettingsController do
  include_context 'shared company'

  before { create(:setting, company: shared_company) unless Setting.exists? }

  describe 'GET /settings/edit' do
    subject(:action) { get '/settings/edit' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /settings' do
    subject(:action) do
      patch '/settings', params: { setting: params }
    end

    let(:params) { {} }

    before do
      stub_const('MAXIMUM_CHAPTERS_COUNT', 10)
    end

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      context 'when params are invalid' do
        let(:params) do
          { chapter_options: { maximum_chapters_count: 12 } }
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) do
          { chapter_options: { maximum_chapters_count: 8 } }
        end

        include_examples 'a redirect response with success message' do
          let(:message) { 'Les paramètres ont bien été mis à jour' }
          let(:url_to_redirect) { edit_settings_path }
        end
      end
    end
  end
end
