require 'rails_helper'

RSpec.describe Stories::Chapters::CoversController do
  include_context 'shared company'

  describe 'PATCH /stories/:story_id/chapters/:chapter_id/covers' do
    subject(:action) { patch "/stories/#{story.id}/chapters/#{chapter.id}/covers" }

    let(:story) { create :story, company: shared_company }
    let(:chapter) { create :chapter, story: story, summary: 'my chapter summary' }

    before do
      allow(ReplicateServices::Picture).to receive(:call)
    end

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      describe '[replicate service]' do
        before { action }

        it { expect(ReplicateServices::Picture).to have_received(:call).with(chapter, 'my chapter summary') }
      end

      include_examples 'a redirect response with success message' do
        let(:message) { 'La couverture du chapitre est en cours de création' }
        let(:url_to_redirect) { root_path }
      end
    end
  end
end
