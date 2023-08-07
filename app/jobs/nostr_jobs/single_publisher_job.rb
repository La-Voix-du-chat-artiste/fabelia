module NostrJobs
  class SinglePublisherJob < ApplicationJob
    def perform(chapter)
      story = chapter.story

      raise StoryErrors::MissingCover unless story.cover.attached?

      NostrPublisherService.call(chapter)
      chapter.broadcast_chapter
      story.broadcast_next_quick_look_story if story.publishable_story?
    end
  end
end
