module NostrJobs
  class AllPublisherJob < NostrJob
    retry_on StoryErrors::MissingCover,
             ChapterErrors::PreviousChapterNotPublished,
             wait: 10.seconds,
             jitter: 0.30,
             attempts: 25

    def perform(story)
      raise StoryErrors::MissingCover unless story.cover.attached?

      story.chapters.not_published.not_draft.by_position.each do |chapter|
        NostrPublisherService.call(chapter)
        sleep 1
      end

      flash_message = "Tous les chapitres viennent d'être publiés sur Nostr"
      Story.broadcast_flash(:notice, flash_message)
    end
  end
end
