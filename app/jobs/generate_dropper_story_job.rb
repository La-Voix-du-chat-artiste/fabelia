class GenerateDropperStoryJob < GenerateStoryJob
  RETRYABLE_AI_ERRORS = [
    Net::ReadTimeout,
    JSON::ParserError,
    OpenaiChatgpt::Error,
    ChapterErrors::EmptyPollOptions,
    ChapterErrors::MissingPollOptions
  ].freeze

  # @param draft_story [Story] draft story to generate
  def perform(draft_story)
    validate!(draft_story)
    process!(draft_story, RETRYABLE_AI_ERRORS)
  end

  private

  def validate!(draft_story)
    super(draft_story)

    raise NostrUserErrors::EmptyLightningNetworkAddress if draft_story.nostr_user.lud16.blank?
  end

  def options
    @options ||= Setting.first.chapter_options
  end
end
