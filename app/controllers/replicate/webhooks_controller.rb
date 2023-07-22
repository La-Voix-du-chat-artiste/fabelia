module Replicate
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    # @route POST /replicate/webhook (replicate_webhook)
    def event
      model = ReplicateServices::Webhook.call(prediction, model_class)

      model.broadcast_chapter if model.is_a?(Chapter)

      head :ok
    rescue StandardError => e
      Rails.logger.error { ActiveSupport::LogSubscriber.new.send(:color, e.message, :red) }

      head :unprocessable_entity
    end

    # @route POST /replicate/webhook/publish (replicate_webhook_publish)
    def publish
      chapter = ReplicateServices::Webhook.call(prediction, model_class)

      NostrPublisherService.call(chapter)

      chapter.broadcast_chapter

      head :ok
    rescue StandardError => e
      Rails.logger.error { ActiveSupport::LogSubscriber.new.send(:color, e.message, :red) }

      head :unprocessable_entity
    end

    private

    def prediction
      Replicate::Record::Prediction.new(
        Replicate.client,
        JSON.parse(request.body.read)
      )
    end

    def model_class
      params[:model]
    end
  end
end
