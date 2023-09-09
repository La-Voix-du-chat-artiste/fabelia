module Replicate
  class WebhooksController < ApplicationController
    skip_before_action :require_login
    skip_before_action :verify_authenticity_token

    rescue_from StandardError, Replicate::Error do |e|
      broadcast_flash_alert(e)

      head :ok
    end

    rescue_from CoverErrors::NSFWDetected do |e|
      broadcast_flash_alert(e)

      ReplicateServices::Picture.call(e.model, e.model.summary)

      head :ok
    end

    # @route POST /replicate/webhook (replicate_webhook)
    def event
      model = ReplicateServices::Webhook.call(prediction, model_class)

      if model.is_a?(Chapter)
        model.broadcast_chapter
        model.refresh_chapter_details
      end

      model.broadcast_cover if model.is_a?(Story)

      story = model.is_a?(Story) ? model : model.story
      story.broadcast_next_quick_look_story if story.publishable_story?

      head :ok
    end

    # @route POST /replicate/webhook/publish (replicate_webhook_publish)
    def publish
      chapter = ReplicateServices::Webhook.call(prediction, model_class)

      NostrJobs::SinglePublisherJob.perform_later(chapter)

      head :ok
    rescue ChapterErrors::PreviousChapterNotPublished,
           StoryErrors::MissingCover => e
      broadcast_flash_alert(e)

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

      ApplicationRecord.broadcast_flash(
        :alert, "[#{e.class}] #{I18n.l(Time.current)} :: #{e.message}"
      )
    end
  end
end
