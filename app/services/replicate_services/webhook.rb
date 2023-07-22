require 'open-uri'

module ReplicateServices
  class Webhook < ApplicationService
    attr_reader :prediction, :model_class

    def initialize(prediction, model_class)
      @prediction = prediction
      @model_class = model_class
    end

    def call
      model.update(replicate_raw_response_body: prediction.as_json)

      model.cover.attach(
        io: URI.parse(prediction.output.last).open,
        filename: prediction.id
      )

      model
    end

    private

    def model
      @model ||= begin
        parsed_class = case model_class
                       when 'Chapter' then Chapter
                       when 'Story' then Story
                       else
                         raise StandardError, 'Unknown model class'
        end

        parsed_class.find_by!(replicate_identifier: prediction.id)
      end
    end
  end
end
