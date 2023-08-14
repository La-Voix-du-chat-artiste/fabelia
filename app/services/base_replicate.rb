class BaseReplicate < ApplicationService
  include Rails.application.routes.url_helpers

  private

  def model_replicate
    Replicate.client.retrieve_model('stability-ai/stable-diffusion')
  end

  def version
    model_replicate.latest_version
  end

  def host
    Rails.application.config.action_controller.default_url_options[:host]
  end

  def default_keywords
    Setting.first.chapter_options.stable_diffusion_prompt
  end
end
