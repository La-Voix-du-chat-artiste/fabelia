require 'open-uri'

module ReplicateServices
  class Webhook < ApplicationService
    attr_reader :prediction

    def initialize(prediction)
      @prediction = prediction
    end

    def call
      chapter.update(raw_response_body: prediction.as_json)

      chapter.cover.attach(
        io: URI.parse(prediction.output.last).open,
        filename: prediction.id
      )

      chapter
    end

    private

    def chapter
      @chapter ||= Chapter.find_by!(replicate_identifier: prediction.id)
    end
  end
end
