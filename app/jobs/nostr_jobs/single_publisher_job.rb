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

      NostrPublisherService.call(chapter)
    end
  end
end
