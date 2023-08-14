require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'homes#show'

  mount Sidekiq::Web => '/sidekiq'

  post '/replicate/webhook', to: 'replicate/webhooks#event'
  post '/replicate/webhook/publish', to: 'replicate/webhooks#publish'

  resource :sessions, only: %i[new create destroy]
  resources :password_resets, only: %i[new create edit update]

  resources :stories, only: %i[create update destroy] do
    scope module: :stories do
      resource :covers, only: %i[update]

      resources :chapters, only: %i[create] do
        scope module: :chapters do
          resource :covers, only: %i[update]
        end

        collection do
          post :publish_next
          post :publish_all
        end

        member do
          post :publish
        end
      end
    end
  end

  resources :nostr_users, except: :show do
    scope module: :nostr_users do
      member do
        resource :refresh_profiles, only: :create
      end
    end
  end

  resources :relays, except: :show
  resources :thematics, except: :show

  resource :settings, only: %i[show edit update]
  resolve('Setting') { [:settings] }
end
