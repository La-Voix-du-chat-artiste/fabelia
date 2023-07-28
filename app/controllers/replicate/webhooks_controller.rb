module Replicate
  class WebhooksController < ApplicationController
    skip_before_action :require_login
    skip_before_action :verify_authenticity_token

    # @route POST /replicate/webhook (replicate_webhook)
    def event
      model = ReplicateServices::Webhook.call(prediction, model_class)

      model.broadcast_chapter if model.is_a?(Chapter)
      model.broadcast_cover if model.is_a?(Story)

      head :ok
    rescue Replicate::Error => e
      model = ReplicateServices::Webhook.new(prediction, model_class).model

      Rails.logger.error do
        ActiveSupport::LogSubscriber.new.send(:color, "#{e.message} / #{model.inspect}", :red)
      end

      ReplicateServices::Picture.call(model, model.summary)

      head :ok
    rescue StandardError => e
      Rails.logger.error { ActiveSupport::LogSubscriber.new.send(:color, e.message, :red) }

      head :ok
    end

    # @route POST /replicate/webhook/publish (replicate_webhook_publish)
    def publish
      chapter = ReplicateServices::Webhook.call(prediction, model_class)

      unless chapter.published?
        NostrPublisherService.call(chapter)
        chapter.broadcast_chapter
      end

      head :ok
    rescue Replicate::Error => e
      model = ReplicateServices::Webhook.new(prediction, model_class).model

      Rails.logger.error do
        ActiveSupport::LogSubscriber.new.send(:color, "#{e.message} / #{model.inspect}", :red)
      end

      ReplicateServices::Picture.call(model, model.summary)

      head :ok
    rescue StandardError => e
      Rails.logger.error { ActiveSupport::LogSubscriber.new.send(:color, e.message, :red) }

      head :ok
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
