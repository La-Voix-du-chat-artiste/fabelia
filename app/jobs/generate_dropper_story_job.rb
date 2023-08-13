class GenerateDropperStoryJob < GenerateStoryJob
  RETRYABLE_AI_ERRORS = [
    Net::ReadTimeout,
    JSON::ParserError,
    ChapterErrors::EmptyPollOptions,
    ChapterErrors::MissingPollOptions
  ].freeze

  # @param draft_story [Story] draft story to generate
  def perform(draft_story)
    validate!(draft_story)
    process!(draft_story, RETRYABLE_AI_ERRORS, publish: true)
  end
end
