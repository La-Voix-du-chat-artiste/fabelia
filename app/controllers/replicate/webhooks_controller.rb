module Replicate
  class WebhooksController < ApplicationController
    skip_before_action :require_login
    skip_before_action :verify_authenticity_token

    rescue_from StandardError do |e|
      broadcast_flash_alert(e)

      head :ok
    end

    # @route POST /replicate/webhook (replicate_webhook)
    def event
      model = ReplicateServices::Webhook.call(prediction, model_class)

      model.broadcast_chapter if model.is_a?(Chapter)
      model.broadcast_cover if model.is_a?(Story)

      story = model.is_a?(Story) ? model : model.story
      story.broadcast_next_quick_look_story if story.publishable_story?

      head :ok
    rescue Replicate::Error, CoverErrors::NSFWDetected => e
      broadcast_flash_alert(e)

      model = ReplicateServices::Webhook.new(prediction, model_class).model
      ReplicateServices::Picture.call(model, model.summary)

      head :ok
    end

    # @route POST /replicate/webhook/publish (replicate_webhook_publish)
    def publish
      chapter = ReplicateServices::Webhook.call(prediction, model_class)
      story = chapter.story

      raise StoryErrors::MissingCover unless story.cover.attached?

      unless chapter.published?
        NostrPublisherService.call(chapter)
        chapter.broadcast_chapter

        story.broadcast_next_quick_look_story if story.publishable_story?
      end

      head :ok
    rescue Replicate::Error, CoverErrors::NSFWDetected => e
      broadcast_flash_alert(e)

      model = ReplicateServices::Webhook.new(prediction, model_class).model
      ReplicateServices::Picture.call(model, model.summary)

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

    def broadcast_flash_alert(e)
      Rails.logger.tagged(e.class) do
        Rails.logger.error do
          ActiveSupport::LogSubscriber.new.send(:color, e.message, :red)
        end
      end

      Turbo::StreamsChannel.broadcast_prepend_to(
        :flashes,
        target: 'flashes',
        partial: 'flash',
        locals: {
          flash_type: 'alert',
          message: "#{I18n.l(Time.current)} :: #{e.message}"
        }
      )
    end
  end
end
