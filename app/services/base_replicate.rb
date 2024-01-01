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
    return ENV.fetch('HOST', nil) if Rails.env.development?

    ENV.fetch('BASE_URL')
  end
end
