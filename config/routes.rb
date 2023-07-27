Rails.application.routes.draw do
  root to: 'homes#show'

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

  resources :nostr_users, except: :show
  resources :thematics
end
