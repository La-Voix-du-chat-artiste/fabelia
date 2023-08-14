module NostrJobs
  class StoryDeletionJob < NostrJob
    def perform(story)
      NostrServices::StoryDeletionEvent.call(story)

      story.destroy!

      flash_message = "L'aventure vient d'être supprimée sur Nostr"
      Story.broadcast_flash(:notice, flash_message)
    end
  end
end
