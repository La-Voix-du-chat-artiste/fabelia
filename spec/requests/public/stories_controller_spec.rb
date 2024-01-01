require 'rails_helper'

RSpec.describe Public::StoriesController do
  describe 'GET /p/s/:id.pdf' do
    subject(:action) { get "/p/s/#{story.id}.pdf" }

    context 'when story is viewable as PDF' do
      let(:story) { create :story, :ended }

      before do
        create :chapter, :published, story: story
        action
      end

      it { expect(response).to have_http_status :ok }
    end

    context 'when story is not viewable as PDF' do
      let(:story) { create :story }

      before { action }

      it { expect(response).to have_http_status :found }
      it { expect(response).to redirect_to new_sessions_path }
      it { expect(flash[:alert]).to eq I18n.t('action_policy.public/story_policy.show?') }
    end
  end
end
