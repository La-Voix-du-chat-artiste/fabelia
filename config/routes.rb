Rails.application.routes.draw do
  root to: 'homes#show'

  post '/replicate/webhook', to: 'replicate/webhooks#event'

  resources :stories, only: %i[create update]
end
