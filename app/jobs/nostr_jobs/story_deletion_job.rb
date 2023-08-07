module NostrJobs
  class StoryDeletionJob < NostrJob
    def perform(story)
      NostrServices::StoryDeletionEvent.call(story)

      story.destroy!
    end
  end
end
