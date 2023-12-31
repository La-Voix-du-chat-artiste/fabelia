require 'rails_helper'

RSpec.describe NostrUsersController do
  include_context 'shared company'

  describe 'GET /nostr_users' do
    subject(:action) { get '/nostr_users' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      context 'without record' do
        before { action }

        it { expect(response).to have_http_status :ok }
      end

      context 'with some record' do
        before do
          create_list :nostr_user, 2, company: shared_company
          action
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  describe 'GET /nostr_users/new' do
    subject(:action) { get '/nostr_users/new' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /nostr_users' do
    subject(:action) { post '/nostr_users', params: { nostr_user: params } }

    let(:params) { {} }
    let!(:relay) { create :relay, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }
      let(:instance) { instance_double(NostrPublisher::Profile) }

      before do
        allow(NostrPublisher::Profile).to receive(:new) { instance }
        allow(instance).to receive(:call)
      end

      context 'when params are invalid' do
        let(:params) do
          attributes_for(:nostr_user)
            .merge(relay_ids: [relay.id], display_name: nil)
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) do
          attributes_for(:nostr_user).merge(relay_ids: [relay.id])
        end

        include_examples 'a redirect response with success message' do
          let(:message) { "Votre compte Nostr vient d'être créé ! ⚠️ Assurez-vous d'avoir fait une sauvegarde de votre clé privée pour ne pas perdre votre compte ⚠️" }
          let(:url_to_redirect) { nostr_users_path }
        end
      end
    end
  end

  describe 'GET /nostr_users/:id/edit' do
    subject(:action) { get "/nostr_users/#{nostr_user.id}/edit" }

    let(:nostr_user) { create :nostr_user, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /nostr_users/:id' do
    subject(:action) do
      patch "/nostr_users/#{nostr_user.id}", params: { nostr_user: params }
    end

    let(:params) { {} }
    let(:nostr_user) { create :nostr_user, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }
      let(:instance) { instance_double(NostrPublisher::Profile) }

      before do
        allow(NostrPublisher::Profile).to receive(:new) { instance }
        allow(instance).to receive(:call)
      end

      context 'when params are invalid' do
        let(:params) { { display_name: nil } }

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { { private_key: FFaker::Crypto.sha256 } }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Le compte Nostr a bien été mis à jour.' }
          let(:url_to_redirect) { nostr_users_path }
        end
      end

      describe 'language cannot be modified' do
        let(:nostr_user) do
          create :nostr_user, language: 'FR', company: shared_company
        end
        let(:params) { { language: 'ES' } }

        before { action }

        it { expect(nostr_user.reload.language).to eq 'FR' }
      end
    end
  end

  describe 'DELETE /nostr_users/:id' do
    subject(:action) { delete "/nostr_users/#{nostr_user.id}" }

    let!(:nostr_user) { create :nostr_user, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Le compte Nostr a bien été supprimé.' }
        let(:url_to_redirect) { nostr_users_path }
      end

      it { expect { action }.to change { NostrUser.count }.by(-1) }
    end
  end
end
