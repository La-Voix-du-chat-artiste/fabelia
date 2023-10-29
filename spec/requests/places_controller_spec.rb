require 'rails_helper'

RSpec.describe PlacesController do
  include_context 'shared company'

  describe 'GET /places' do
    subject(:action) { get '/places' }

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
          create_list :place, 2, company: shared_company
          action
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  describe 'GET /places/new' do
    subject(:action) { get '/places/new' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /places' do
    subject(:action) { post '/places', params: { place: params } }

    let(:params) { {} }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when params are invalid' do
        let(:params) do
          attributes_for(:place).merge(name: nil)
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { attributes_for :place }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Le lieu a bien été ajouté' }
          let(:url_to_redirect) { places_path }
          let(:http_status) { :see_other }
        end
      end
    end
  end

  describe 'GET /places/:id/edit' do
    subject(:action) { get "/places/#{place.id}/edit" }

    let(:place) { create :place, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /places/:id' do
    subject(:action) do
      patch "/places/#{place.id}", params: { place: params }
    end

    let(:params) { {} }
    let(:place) { create :place, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when params are invalid' do
        let(:params) { { name: nil } }

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { { name_fr: 'Foobar' } }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Le lieu a bien été modifié' }
          let(:url_to_redirect) { places_path }
          let(:http_status) { :see_other }
        end
      end
    end
  end

  describe 'DELETE /places/:id' do
    subject(:action) { delete "/places/#{place.id}" }

    let!(:place) { create :place, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Le lieu a bien été supprimé' }
        let(:url_to_redirect) { places_path }
        let(:http_status) { :see_other }
      end

      it { expect { action }.to change { Place.count }.by(-1) }
    end
  end
end
