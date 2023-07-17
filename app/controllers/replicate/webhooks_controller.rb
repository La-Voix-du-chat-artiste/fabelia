module Replicate
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    # @route POST /replicate/webhook (replicate_webhook)
    def event
      chapter = ReplicateServices::Webhook.call(prediction)
      story = chapter.story

      # TODO: when live to production replace Replicate URL
      # by our own server
      cover = prediction.output.first
      # cover = rails_storage_proxy_url(chapter.cover, port: nil, protocol: 'https')

      if story.current?
        last_published = chapter.last_published

        @command = <<~COMMAND
          noscl publish --reference #{last_published.nostr_identifier} "#{chapter.title}\n\n#{chapter.content}\n\n#{cover}"
        COMMAND
      else
        @command = <<~COMMAND
          noscl publish "#{story.title}\n\n#{chapter.title}\n\n#{chapter.content}\n\n#{cover}"
        COMMAND
      end

      IO.popen(@command) do |pipe|
        @output = pipe.readlines
      end

      event_id = @output.last.split[1]

      chapter.update!(
        nostr_identifier: event_id,
        published_at: Time.current
      )

      story.ended! if chapter.last_published?

      head :ok
    rescue StandardError => e
      Rails.logger.error { "========> #{e.message} <=======" }

      head :unprocessable_entity
    end

    private

    def prediction
      Replicate::Record::Prediction.new(
        Replicate.client,
        JSON.parse(request.body.read)
      )
    end
  end
end
