class GenerateDropperChapterJob < GenerateDropperStoryJob
  private

  def perform(draft_story, force_ending: false)
    validate!(draft_story)

    prompt = if force_ending
      "Termine l'aventure de manière cohérente avec un tout dernier chapitre"
    else
      draft_story.chapters.published.last.most_voted_option
    end

    Story.broadcast_flash(:info, "Prompt utilisé: #{prompt}")

    Retry.on(*RETRYABLE_AI_ERRORS) do
      @json = ChatgptDropperService.call(
        prompt, draft_story.nostr_user.language, draft_story
      )
    end

    chapter_accurate_cover_prompt = ChatgptSummaryService.call(@json['content'])

    @chapter = draft_story.chapters.create!(
      title: @json['title'],
      content: @json['content'],
      summary: chapter_accurate_cover_prompt,
      prompt: prompt,
      chat_raw_response_body: @json,
      publish: draft_story.publish_me?
    )
  end
end
