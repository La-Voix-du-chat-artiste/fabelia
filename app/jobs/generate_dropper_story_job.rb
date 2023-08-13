class GenerateDropperStoryJob < GenerateStoryJob
  RETRYABLE_AI_ERRORS = [
    Net::ReadTimeout,
    JSON::ParserError,
    ChapterErrors::EmptyPollOptions,
    ChapterErrors::MissingPollOptions
  ]

  # TODO: Validate that a nostr_user is enabled for a language or raise
  # TODO: Validate that thematic is properly enabled or raise
  # @param draft_story [Story] draft story to generate
  def perform(draft_story)
    process!(draft_story, RETRYABLE_AI_ERRORS, publish: true)
  end
end
