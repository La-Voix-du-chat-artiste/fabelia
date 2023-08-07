module NostrJobs
  class StoryDeletionJob < ApplicationJob
    def perform(story)
      NostrServices::StoryDeletionEvent.call(story)

      story.destroy!
    end
  end
end
