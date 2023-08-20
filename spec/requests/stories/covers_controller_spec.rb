require 'rails_helper'

RSpec.describe Stories::CoversController do
  describe 'PATCH /stories/:story_id/covers' do
    subject(:action) { patch "/stories/#{story.id}/covers" }

    let(:story) { create :story, summary: 'my story summary' }

    before do
      allow(ReplicateServices::Picture).to receive(:call)
    end

    it_behaves_like 'a user not logged in'
    it_behaves_like 'unauthorized request when logged in as standard'

    context 'when logged in with proper accreditation', as: :logged_in do
      let(:role) { :admin }

      describe '[replicate service]' do
        before { action }

        it { expect(ReplicateServices::Picture).to have_received(:call).with(story, 'my story summary') }
      end

      include_examples 'a redirect response with success message' do
        let(:message) { "La couverture de l'histoire est en cours de création" }
        let(:url_to_redirect) { root_path }
      end
    end
  end
end
