require 'rails_helper'

RSpec.describe NostrUsersController do
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
          create_list :nostr_user, 2
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
    let!(:relay) { create :relay }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }
      let(:instance) { instance_double(NostrAccounts::PublishProfile) }

      before do
        allow(NostrAccounts::PublishProfile).to receive(:new) { instance }
        allow(instance).to receive(:build_and_publish_event)
      end

      context 'when params are invalid' do
        let(:params) do
          attributes_for(:nostr_user)
            .merge(relay_ids: [relay.id], name: nil)
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

    let(:nostr_user) { create :nostr_user }

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
    let(:nostr_user) { create :nostr_user }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }
      let(:instance) { instance_double(NostrAccounts::PublishProfile) }

      before do
        allow(NostrAccounts::PublishProfile).to receive(:new) { instance }
        allow(instance).to receive(:build_and_publish_event)
      end

      context 'when params are invalid' do
        let(:params) { { name: nil } }

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { { private_key: Faker::Crypto.sha256 } }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Nostr user was successfully updated.' }
          let(:url_to_redirect) { nostr_users_path }
        end
      end
    end
  end

  describe 'DELETE /nostr_users/:id' do
    subject(:action) { delete "/nostr_users/#{nostr_user.id}" }

    let!(:nostr_user) { create :nostr_user }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Nostr user was successfully destroyed.' }
        let(:url_to_redirect) { nostr_users_path }
      end

      it { expect { action }.to change { NostrUser.count }.by(-1) }
    end
  end
end
