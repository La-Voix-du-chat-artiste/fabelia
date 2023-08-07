module NostrJobs
  class AllPublisherJob < ApplicationJob
    def perform(story)
      raise StoryErrors::MissingCover unless story.cover.attached?

      story.chapters.not_published.by_position.each do |chapter|
        NostrPublisherService.call(chapter)
        chapter.broadcast_chapter
        story.broadcast_next_quick_look_story if story.publishable_story?

        sleep 2
      end
    end
  end
end
