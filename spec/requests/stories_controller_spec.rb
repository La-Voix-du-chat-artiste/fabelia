require 'rails_helper'

RSpec.describe StoriesController do
  include_context 'shared company'

  describe 'POST /stories' do
    subject(:action) { post '/stories', params: { story: params } }

    let(:params) { {} }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      let(:thematic) { create :thematic, company: shared_company }
      let(:nostr_user) { create :nostr_user, company: shared_company }
      let(:media_prompt) { create :media_prompt, company: shared_company }
      let(:narrator_prompt) { create :narrator_prompt, company: shared_company }
      let(:atmosphere_prompt) { create :atmosphere_prompt, company: shared_company }
      let(:mode) { :complete }

      let(:params) do
        {
          mode: mode,
          thematic_id: thematic.id,
          nostr_user_id: nostr_user.id,
          media_prompt_id: media_prompt.id,
          narrator_prompt_id: narrator_prompt.id,
          atmosphere_prompt_id: atmosphere_prompt.id
        }
      end

      context 'when mode is dropper' do
        let(:mode) { :dropper }

        it { expect { action }.to have_enqueued_job(GenerateDropperStoryJob).with(instance_of(Story)) }

        it { expect { action }.to change { Story.count }.by(1) }

        it_behaves_like 'a redirect response with success message' do
          let(:message) { 'Le premier chapitre de cette nouvelle aventure est en cours de création' }
          let(:url_to_redirect) { root_path }
        end
      end

      context 'when mode is complete' do
        let(:mode) { :complete }

        it { expect { action }.to have_enqueued_job(GenerateFullStoryJob).with(instance_of(Story)) }

        it { expect { action }.to change { Story.count }.by(1) }

        it_behaves_like 'a redirect response with success message' do
          let(:message) { "L'aventure pré-générée est en cours de création, veuillez patienter le temps que ChatGPT et Replicate finissent de tout générer." }
          let(:url_to_redirect) { root_path }
        end
      end
    end
  end

  describe 'PATCH /stories/:id' do
    subject(:action) { patch "/stories/#{story.id}" }

    let(:story) { create :story, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when story is enabled' do
        let(:story) { create :story, :enabled, company: shared_company }

        it { expect { action }.to change { story.reload.enabled }.from(true).to(false) }

        it_behaves_like 'a redirect response with success message' do
          let(:message) { "L'aventure a bien été mise à jour" }
          let(:url_to_redirect) { root_path }
        end
      end

      context 'when story is disabled' do
        let(:story) { create :story, :disabled, company: shared_company }

        it { expect { action }.to change { story.reload.enabled }.from(false).to(true) }

        it_behaves_like 'a redirect response with success message' do
          let(:message) { "L'aventure a bien été mise à jour" }
          let(:url_to_redirect) { root_path }
        end
      end
    end
  end

  describe 'DELETE /stories/:id' do
    subject(:action) { delete "/stories/#{story.id}" }

    let!(:story) { create :story, company: shared_company }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { "L'aventure est en cours de suppression" }
        let(:url_to_redirect) { root_path }
      end

      it { expect { action }.to have_enqueued_job(NostrJobs::StoryDeletionJob).with(story) }
    end
  end
end
