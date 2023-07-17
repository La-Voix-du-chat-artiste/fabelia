class BaseReplicate < ApplicationService
  include Rails.application.routes.url_helpers

  private

  def model
    Replicate.client.retrieve_model('stability-ai/stable-diffusion')
  end

  def version
    model.latest_version
  end

  def host
    Rails.application.config.action_controller.default_url_options[:host]
  end

  def webhook_url
    replicate_webhook_url(host: host)
  end

  def default_keywords
    '. fantasy, very very beautiful, elegant, highly detailed, realistic, depth'
  end
end
