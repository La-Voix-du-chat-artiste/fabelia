module NSFWCoverable
  extend ActiveSupport::Concern

  NSFW_ERROR_PATTERN = 'NSFW content detected'.freeze

  def nsfw_prediction?
    return false if replicate_error.nil?

    replicate_error.include?(NSFW_ERROR_PATTERN)
  end

  private

  def replicate_error
    replicate_raw_response_body.dig('data', 'error')
  end
end
