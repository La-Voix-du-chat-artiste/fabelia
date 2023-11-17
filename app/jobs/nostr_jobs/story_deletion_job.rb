module NostrJobs
  class StoryDeletionJob < NostrJob
    def perform(story)
      event = NostrBuilder::StoryDeletionEvent.call(story)
      NostrBroadcaster.call(story.nostr_user, event)

      story.destroy!

      flash_message = "L'aventure vient d'être supprimée sur Nostr"
      Story.broadcast_flash(:notice, flash_message)
    end
  end
end
