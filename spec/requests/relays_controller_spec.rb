require 'rails_helper'

RSpec.describe RelaysController do
  describe 'GET /relays' do
    subject(:action) { get '/relays' }

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
          create_list :relay, 2
          action
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  describe 'GET /relays/new' do
    subject(:action) { get '/relays/new' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /relays' do
    subject(:action) { post '/relays', params: { relay: params } }

    let(:params) { {} }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      context 'when params are invalid' do
        let(:params) do
          attributes_for(:relay).merge(url: nil)
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { attributes_for :relay }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Relay was successfully created.' }
          let(:url_to_redirect) { relays_path }
          let(:http_status) { :see_other }
        end
      end
    end
  end

  describe 'GET /relays/:id/edit' do
    subject(:action) { get "/relays/#{relay.id}/edit" }

    let(:relay) { create :relay }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /relays/:id' do
    subject(:action) do
      patch "/relays/#{relay.id}", params: { relay: params }
    end

    let(:params) { {} }
    let(:relay) { create :relay }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      context 'when params are invalid' do
        let(:params) { { url: nil } }

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { { identifier: 'Foobar' } }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Relay was successfully updated.' }
          let(:url_to_redirect) { relays_path }
          let(:http_status) { :see_other }
        end
      end
    end
  end

  describe 'DELETE /relays/:id' do
    subject(:action) { delete "/relays/#{relay.id}" }

    let!(:relay) { create :relay }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'
    it_behaves_like 'unauthorized request when logged in as admin'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :super_admin }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Relay was successfully destroyed.' }
        let(:url_to_redirect) { relays_path }
      end

      it { expect { action }.to change { Relay.count }.by(-1) }
    end
  end
end
