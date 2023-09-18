require 'rails_helper'

RSpec.describe PromptsController do
  describe 'GET /prompts' do
    subject(:action) { get '/prompts', params: params }

    let(:params) { {} }

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
          create_list :narrator_prompt, 2
          action
        end

        it { expect(response).to have_http_status :ok }
      end

      context 'with archived records' do
        let(:params) { { archived: true } }

        before do
          create :narrator_prompt
          create :narrator_prompt, :archived

          action
        end

        it { expect(response).to have_http_status :ok }
      end
    end
  end

  describe 'GET /prompts/new' do
    subject(:action) { get '/prompts/new', params: { type: type } }

    let(:type) { nil }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when type is not present' do
        let(:correct_type) { Base64.encode64('NarratorPrompt') }

        before { action }

        it { expect(response).to have_http_status :found }
        it { expect(response).to redirect_to new_prompt_path(type: correct_type) }
      end

      context 'when type is present' do
        let(:type) { Base64.encode64('NarratorPrompt') }

        before { action }

        it { expect(response).to have_http_status :ok }
      end

      context 'when type is not handled' do
        let(:type) { Base64.encode64('fake') }
        let(:correct_type) { Base64.encode64('NarratorPrompt') }

        before { action }

        it { expect(response).to have_http_status :found }
        it { expect(response).to redirect_to new_prompt_path(type: correct_type) }
      end
    end
  end

  describe 'POST /prompts' do
    subject(:action) do
      post '/prompts', params: { "#{prompt_kind}": params, type: type }
    end

    let(:params) { {} }
    let(:prompt_kind) { :narrator_prompt }
    let(:type) { Base64.encode64(prompt_kind.to_s.camelize) }
    let(:relay) { create :relay }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      %i[media_prompt narrator_prompt atmosphere_prompt].each do |kind|
        describe "with #{kind} prompt type" do
          let(:prompt_kind) { kind }

          context 'when params are invalid' do
            let(:params) do
              attributes_for(prompt_kind).merge(title: nil)
            end

            before { action }

            it { expect(response).to have_http_status :unprocessable_entity }
          end

          context 'when params are valid' do
            let(:params) { attributes_for prompt_kind }

            include_examples 'a redirect response with success message' do
              let(:message) { 'Le prompt a bien été créé.' }
              let(:url_to_redirect) { prompts_path }
            end
          end
        end
      end

      context 'when type is not handled' do
        let(:type) { Base64.encode64('Foobar') }

        include_examples 'a redirect response with alert message' do
          let(:message) { 'Type de prompt inconnu' }
          let(:url_to_redirect) { new_prompt_path }
        end
      end
    end
  end

  describe 'GET /prompts/:id/edit' do
    subject(:action) { get "/prompts/#{prompt.id}/edit" }

    let(:prompt) { create :narrator_prompt }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before { action }

      it { expect(response).to have_http_status :ok }
    end
  end

  describe 'PATCH /prompts/:id' do
    subject(:action) do
      patch "/prompts/#{prompt.id}", params: { "#{prompt_kind}": params }
    end

    let(:params) { {} }
    let(:prompt_kind) { :narrator_prompt }
    let(:prompt) { create :narrator_prompt }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      %i[media_prompt narrator_prompt atmosphere_prompt].each do |kind|
        describe "with #{kind} prompt type" do
          let(:prompt_kind) { kind }
          let(:prompt) { create kind }

          context 'when params are invalid' do
            let(:params) { { title: nil } }

            before { action }

            it { expect(response).to have_http_status :unprocessable_entity }
          end

          context 'when params are valid' do
            let(:params) { { title: 'Foobar' } }

            include_examples 'a redirect response with success message' do
              let(:message) { 'Le prompt a été mis à jour avec succès.' }
              let(:url_to_redirect) { prompts_path }
              let(:http_status) { :see_other }
            end
          end
        end
      end
    end
  end

  describe 'DELETE /prompts/:id' do
    subject(:action) { delete "/prompts/#{prompt.id}" }

    let!(:prompt) { create :narrator_prompt }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when there is more than one prompt' do
        before do
          create :narrator_prompt
        end

        it_behaves_like 'a redirect response with success message' do
          let(:message) { 'Le prompt a bien été supprimé.' }
          let(:url_to_redirect) { prompts_path }
        end

        it { expect { action }.to change { Prompt.count }.by(-1) }
      end

      context 'when there is only one remaining prompt' do
        it_behaves_like 'a redirect response with alert message' do
          let(:message) { "Vous n'avez pas l'autorisation d'effectuer cette action." }
          let(:url_to_redirect) { root_path }
        end

        it { expect { action }.to_not change { Prompt.count } }
      end
    end
  end

  describe 'POST /prompts/:id/archive' do
    subject(:action) { post "/prompts/#{prompt.id}/archive" }

    let!(:prompt) { create :narrator_prompt, archived_at: archived_at }
    let(:archived_at) { nil }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when prompt is archived' do
        let(:archived_at) { Time.current }

        it_behaves_like 'a redirect response with success message' do
          let(:message) { 'Le prompt a bien été désarchivé' }
          let(:url_to_redirect) { prompts_path }
        end

        it { expect { action }.to change { prompt.reload.archived_at }.to(nil) }
      end

      context 'when prompt is not archived' do
        let(:archived_at) { nil }

        it_behaves_like 'a redirect response with success message' do
          let(:message) { 'Le prompt a bien été archivé' }
          let(:url_to_redirect) { prompts_path }
        end

        it { expect { action }.to change { prompt.reload.archived_at }.from(nil) }
      end
    end
  end
end
