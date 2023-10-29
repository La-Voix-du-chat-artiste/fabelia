require 'rails_helper'

RSpec.describe CharactersController do
  include_context 'shared company'

  describe 'GET /characters' do
    subject(:action) { get '/characters' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'without record' do
        before { action }

        it { expect(response).to have_http_status :ok }
      end

      context 'with some record' do
        before do
          create_list :character, 2, company: shared_company
          action
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  describe 'GET /characters/new' do
    subject(:action) { get '/characters/new' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /characters' do
    subject(:action) { post '/characters', params: { character: params } }

    let(:params) { {} }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when params are invalid' do
        let(:params) do
          attributes_for(:character).merge(first_name: nil)
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { attributes_for :character }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Le personnage a bien été créé' }
          let(:url_to_redirect) { characters_path }
          let(:http_status) { :see_other }
        end
      end
    end
  end

  describe 'GET /characters/:id/edit' do
    subject(:action) { get "/characters/#{character.id}/edit" }

    let(:character) { create :character, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /characters/:id' do
    subject(:action) do
      patch "/characters/#{character.id}", params: { character: params }
    end

    let(:params) { {} }
    let(:character) { create :character, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when params are invalid' do
        let(:params) { { first_name: nil } }

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { { identifier: 'Foobar' } }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Le personnage a bien été mis à jour' }
          let(:url_to_redirect) { characters_path }
          let(:http_status) { :see_other }
        end
      end
    end
  end

  describe 'DELETE /characters/:id' do
    subject(:action) { delete "/characters/#{character.id}" }

    let!(:character) { create :character, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Le personnage a bien été supprimé' }
        let(:url_to_redirect) { characters_path }
        let(:http_status) { :see_other }
      end

      it { expect { action }.to change { Character.count }.by(-1) }
    end
  end
end
