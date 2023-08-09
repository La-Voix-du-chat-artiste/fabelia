module Coverable
  extend ActiveSupport::Concern

  included do
    has_one_attached :cover do |attachable|
      attachable.variant :thumb, resize_to_limit: [100, 100]
      attachable.variant :small, resize_to_limit: [300, 300]
    end
  end

  # TODO: Use ActiveStorage version in production
  def replicate_cover
    replicate_raw_response_body['data']['output'].first
  rescue StandardError
    nil
  end
end
