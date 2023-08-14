require 'rails_helper'

RSpec.describe SettingsController do
  before { create :setting }

  describe 'GET /settings' do
    subject(:action) { get '/settings' }

    it_behaves_like 'a user not logged in'

    context 'when logged in', as: :logged_in do
      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'GET /settings/edit' do
    subject(:action) { get '/settings/edit' }

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /settings' do
    subject(:action) do
      patch '/settings', params: { setting: params }
    end

    let(:params) { {} }

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      context 'when params are invalid' do
        let(:params) do
          { chapter_options: { stable_diffusion_prompt: nil }.to_json }
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) do
          { chapter_options: { stable_diffusion_prompt: 'a prompt' }.to_json }
        end

        include_examples 'a redirect response with success message' do
          let(:message) { 'Setting was successfully updated.' }
          let(:url_to_redirect) { settings_path }
        end
      end
    end
  end
end
