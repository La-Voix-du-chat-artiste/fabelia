Rails.application.configure do
  config.lograge.enabled = Rails.env.production?
  config.lograge.ignore_actions = %w[
    ActiveStorage::DiskController#show
    ActiveStorage::RepresentationsController#show
    ActiveStorage::Representations::RedirectController#show
  ]
end
