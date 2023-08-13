require 'rails_helper'

RSpec.describe ThematicsController do
  describe 'GET /thematics' do
    subject(:action) { get '/thematics' }

    it_behaves_like 'a user not logged in'

    context 'when logged in', as: :logged_in do
      context 'without record' do
        before { action }

        it { expect(response).to have_http_status :ok }
      end

      context 'with some record' do
        before do
          create_list :thematic, 2
          action
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  describe 'GET /thematics/new' do
    subject(:action) { get '/thematics/new' }

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'POST /thematics' do
    subject(:action) { post '/thematics', params: { thematic: params } }

    let(:params) { {} }
    let(:relay) { create :relay }

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      context 'when params are invalid' do
        let(:params) do
          attributes_for(:thematic).merge(identifier: nil)
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

    let(:thematic) { create :thematic }

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /thematics/:id' do
    subject(:action) do
      patch "/thematics/#{thematic.id}", params: { thematic: params }
    end

    let(:params) { {} }
    let(:thematic) { create :thematic }

    include_examples 'a user not logged in'

    context 'when logged in', as: :logged_in do
      context 'when params are invalid' do
        let(:params) { { identifier: nil } }

        before { action }

        it { expect(response).to have_http_status :unprocessable_entity }
      end

      context 'when params are valid' do
        let(:params) { { identifier: 'Foobar' } }

        include_examples 'a redirect response with success message' do
          let(:message) { 'Thematic was successfully updated.' }
          let(:url_to_redirect) { thematics_path }
        end
      end
    end
  end

  describe 'DELETE /thematics/:id' do
    subject(:action) { delete "/thematics/#{thematic.id}" }

    let!(:thematic) { create :thematic }

    it_behaves_like 'a user not logged in'

    context 'when logged in', as: :logged_in do
      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Thematic was successfully destroyed.' }
        let(:url_to_redirect) { thematics_path }
      end

      it { expect { action }.to change { Thematic.count }.by(-1) }
    end
  end
end
