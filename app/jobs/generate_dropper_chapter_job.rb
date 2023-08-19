class GenerateDropperChapterJob < GenerateDropperStoryJob
  def perform(story, force_publish: false, force_ending: false)
    validate!(story)

    unless story.chapters.not_draft.last.published?
      if options.publish_previous?
        NostrJobs::AllPublisherJob.perform_now(story)
      else
        last_chapter = story.chapters.last
        current_chapter = story.chapters.new(position: last_chapter.position + 1)

        raise ChapterErrors::PreviousChapterNotPublished.new(current_chapter, last_chapter)
      end
    end

    @chapter = story.chapters.find_or_create_by!(status: :draft)

    prompt = story.chapters.published.last.most_voted_option

    end_of_story = force_ending || story.chapters_count + 1 >= options.maximum_chapters_count

    prompt = "Termine l'aventure de manière cohérente avec un tout dernier chapitre: #{prompt}" if end_of_story

    Story.broadcast_flash(:info, "Prompt:\n#{prompt}")

    Retry.on(*RETRYABLE_AI_ERRORS) do
      @json = ChatgptDropperService.call(
        prompt, story.nostr_user.language, story
      )
    end

    chapter_accurate_cover_prompt = ChatgptSummaryService.call(@json['content'])

    @chapter.update!(
      title: @json['title'],
      content: @json['content'],
      summary: chapter_accurate_cover_prompt,
      prompt: prompt,
      chat_raw_response_body: @json,
      publish: story.publish_me? || force_publish
    )

    @chapter.completed!
  end
end
