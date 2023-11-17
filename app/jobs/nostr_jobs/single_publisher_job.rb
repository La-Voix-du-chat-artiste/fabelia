module NostrJobs
  class SinglePublisherJob < NostrJob
    retry_on StoryErrors::MissingCover,
             ChapterErrors::PreviousChapterNotPublished,
             wait: 10.seconds,
             jitter: 0.30,
             attempts: 25

    def perform(chapter)
      story = chapter.story

      raise StoryErrors::MissingCover unless story.cover.attached?

      NostrPublisher::SmartChapter.call(chapter)

      flash_message = "L'aventure vient d'être publiée sur Nostr"
      Story.broadcast_flash(:notice, flash_message)
    end
  end
end
