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
        num_inference_steps: 20,
        width: 1024,
        height: model.is_a?(Story) ? 1024 : 768
      }, webhook_url)

      debug_logger('Prediction', prediction.inspect, :magenta)

      model.replicate_identifier = prediction.id
      model.replicate_raw_request_body = prediction
      model.save!
    end

    private

    def webhook_url
      return replicate_webhook_publish_url(host: host, model: model.class.to_s) if publish

      replicate_webhook_url(host: host, model: model.class.to_s)
    end
  end
end
