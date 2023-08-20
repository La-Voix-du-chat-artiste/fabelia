require 'rails_helper'

RSpec.describe Stories::ChaptersController do
  describe 'POST /stories/:story_id/chapters' do
    subject(:action) { post "/stories/#{story.id}/chapters", params: params }

    let(:params) { {} }
    let!(:story) { create :story }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when adventure is forced to end' do
        let(:params) { { force_end: true } }

        it { expect { action }.to have_enqueued_job(GenerateDropperChapterJob).with(story, force_publish: true, force_ending: true) }
      end

      context 'when adventure is not asked to be ended' do
        let(:params) { {} }

        it { expect { action }.to have_enqueued_job(GenerateDropperChapterJob).with(story, force_publish: true, force_ending: false) }
      end

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Un nouveau chapitre est en cours de création' }
        let(:url_to_redirect) { root_path }
      end
    end
  end

  describe 'POST /stories/:story_id/chapters/publish_next' do
    subject(:action) { post "/stories/#{story.id}/chapters/publish_next" }

    let(:story) { create :story }
    let!(:chapter) { create :chapter, story: story }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      it { expect { action }.to have_enqueued_job(NostrJobs::SinglePublisherJob).with(chapter) }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Le chapitre est en cours de publication sur Nostr' }
        let(:url_to_redirect) { root_path }
      end
    end
  end

  describe 'POST /stories/:story_id/chapters/publish_all' do
    subject(:action) { post "/stories/#{story.id}/chapters/publish_all" }

    let(:story) { create :story }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      before { create_list :chapter, 3, story: story }

      it { expect { action }.to have_enqueued_job(NostrJobs::AllPublisherJob).with(story) }

      it_behaves_like 'a redirect response with success message' do
        let(:message) { 'Tous les chapitres sont en cours de publication sur Nostr' }
        let(:url_to_redirect) { root_path }
      end
    end
  end

  describe 'POST /stories/:story_id/chapters/:id/publish' do
    subject(:action) { post "/stories/#{story.id}/chapters/#{chapter.id}/publish" }

    let(:story) { create :story }
    let(:chapter) { create :chapter, story: story }

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      context 'when chapter has not been published' do
        let(:chapter) { create :chapter, story: story }

        it { expect { action }.to have_enqueued_job(NostrJobs::SinglePublisherJob).with(chapter) }

        it_behaves_like 'a redirect response with success message' do
          let(:message) { 'Le chapitre est en cours de publication sur Nostr' }
          let(:url_to_redirect) { root_path }
        end
      end

      context 'when chapter has been published' do
        let(:chapter) { create :chapter, :published, story: story }

        it { expect { action }.to_not have_enqueued_job(NostrJobs::SinglePublisherJob) }
      end
    end
  end
end
