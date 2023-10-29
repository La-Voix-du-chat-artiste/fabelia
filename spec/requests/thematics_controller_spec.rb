require 'rails_helper'

RSpec.describe ThematicsController do
  include_context 'shared company'

  describe 'GET /thematics' do
    subject(:action) { get '/thematics' }

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
          create_list :thematic, 2, company: shared_company
          action
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  describe 'GET /thematics/new' do
    subject(:action) { get '/thematics/new' }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /thematics' do
    subject(:action) { post '/thematics', params: { thematic: params } }

    let(:params) { {} }
    let(:relay) { create :relay, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when params are invalid' do
        let(:params) do
          attributes_for(:thematic).merge(name_fr: nil)
        end

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { attributes_for :thematic }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Thematic was successfully created.' }
          let(:url_to_redirect) { thematics_path }
        end
      end
    end
  end

  describe 'GET /thematics/:id/edit' do
    subject(:action) { get "/thematics/#{thematic.id}/edit" }

    let(:thematic) { create :thematic, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /thematics/:id' do
    subject(:action) do
      patch "/thematics/#{thematic.id}", params: { thematic: params }
    end

    let(:params) { {} }
    let(:thematic) { create :thematic, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when params are invalid' do
        let(:params) { { name_fr: nil } }

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { { name_fr: 'Foobar' } }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Thematic was successfully updated.' }
          let(:url_to_redirect) { thematics_path }
        end
      end
    end
  end

  describe 'DELETE /thematics/:id' do
    subject(:action) { delete "/thematics/#{thematic.id}" }

    let!(:thematic) { create :thematic, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Thematic was successfully destroyed.' }
        let(:url_to_redirect) { thematics_path }
      end

      it { expect { action }.to change { Thematic.count }.by(-1) }
    end
  end
end
