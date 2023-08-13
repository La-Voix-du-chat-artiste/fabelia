class GenerateFullStoryJob < GenerateStoryJob
  RETRYABLE_AI_ERRORS = [
    Net::ReadTimeout,
    JSON::ParserError,
    ChapterErrors::FullStoryMissingChapters
  ]

  # TODO: Validate that a nostr_user is enabled for a language or raise
  # TODO: Validate that thematic is properly enabled or raise
  # @param draft_story [Story] draft story to generate
  # @param publish [Boolean] Should the {Chapter} be published ?
  def perform(draft_story, publish: false)
    process!(draft_story, RETRYABLE_AI_ERRORS, publish: publish)
  end
end
