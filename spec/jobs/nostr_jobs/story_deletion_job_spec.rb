require 'rails_helper'

RSpec.describe NostrJobs::StoryDeletionJob do
  let(:job) { described_class.new }

  before do
    allow(NostrServices::StoryDeletionEvent).to receive(:call)
    allow(Story).to receive(:broadcast_flash)
  end

  describe '#perform' do
    subject(:perform) { job.perform(story) }

    let!(:story) { create :story }

    it 'calls deletion service and broadcast flash', :aggregate_failures do
      perform

      expect(NostrServices::StoryDeletionEvent).to have_received(:call).with(story)
      expect(Story).to have_received(:broadcast_flash).with(:notice, "L'aventure vient d'être supprimée sur Nostr")
    end

    it { expect { perform }.to change { Story.count }.by(-1) }
  end
end
