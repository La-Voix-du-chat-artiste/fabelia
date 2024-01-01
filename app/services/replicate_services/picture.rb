module ReplicateServices
  class Picture < BaseReplicate
    attr_reader :model, :prompt, :publish

    def initialize(model, prompt, publish: false)
      @model = model
      @prompt = prompt
      @publish = publish.to_bool
    end

    def call
      debug_logger('Model', model.inspect, :magenta)
      debug_logger('Prompt', prompt, :magenta)
      debug_logger('Webhook URL', webhook_url, :magenta)

      prediction = version.predict({
        prompt: prompt + default_keywords,
        negative_prompt: negative_keywords,
        num_inference_steps: num_inference_steps,
        width: 1024,
        height: model.is_a?(Story) ? 1024 : 768
      }, webhook_url)

      debug_logger('Prediction', prediction.inspect, :magenta)

      model.broadcast_cover_placeholder

      model.replicate_identifier = prediction.id
      model.replicate_raw_request_body = prediction
      model.save!
    end

    private

    def webhook_url
      return replicate_webhook_publish_url(host: host, port: nil, model: model.class.to_s) if publish

      replicate_webhook_url(host: host, port: nil, model: model.class.to_s)
    end

    def story
      model.is_a?(Story) ? model : model.story
    end

    def default_keywords
      story.media_prompt.body
    end

    def negative_keywords
      story.media_prompt.negative_body.presence || ''
    end

    def num_inference_steps
      story.media_prompt.options.num_inference_steps
    end
  end
end
