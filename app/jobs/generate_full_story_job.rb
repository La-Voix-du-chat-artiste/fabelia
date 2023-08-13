class GenerateFullStoryJob < GenerateStoryJob
  RETRYABLE_AI_ERRORS = [
    Net::ReadTimeout,
    JSON::ParserError,
    ChapterErrors::FullStoryMissingChapters
  ].freeze

  # @param draft_story [Story] draft story to generate
  # @param publish [Boolean] Should the {Chapter} be published ?
  def perform(draft_story, publish: false)
    validate!(draft_story)
    process!(draft_story, RETRYABLE_AI_ERRORS, publish: publish)
  end
end
