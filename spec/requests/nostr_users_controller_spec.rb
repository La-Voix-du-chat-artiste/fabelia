require 'rails_helper'

RSpec.describe NostrUsersController do
  before do
    allow(NostrServices::FetchProfile).to receive(:call) { {} }
  end

  describe 'GET /nostr_users' do
    subject(:action) { get '/nostr_users' }

    it_behaves_like 'a user not logged in'

    context 'when logged in', as: :logged_in do
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

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /nostr_users' do
    subject(:action) { post '/nostr_users', params: { nostr_user: params } }

    let(:params) { {} }
    let!(:relay) { create :relay }

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      context 'when params are invalid' do
        let(:params) do
          attributes_for(:nostr_user)
            .merge(relay_ids: [relay.id], private_key: nil)
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) do
          attributes_for(:nostr_user).merge(relay_ids: [relay.id])
        end

        include_examples 'a redirect response with success message' do
          let(:message) { 'Nostr user was successfully created.' }
          let(:url_to_redirect) { nostr_users_path }
        end
      end
    end
  end

  describe 'GET /nostr_users/:id/edit' do
    subject(:action) { get "/nostr_users/#{nostr_user.id}/edit" }

    let(:nostr_user) { create :nostr_user }

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
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

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      context 'when params are invalid' do
        let(:params) { { private_key: nil } }

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

    context 'when logged in', as: :logged_in do
      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Nostr user was successfully destroyed.' }
        let(:url_to_redirect) { nostr_users_path }
      end

      it { expect { action }.to change { NostrUser.count }.by(-1) }
    end
  end
end
