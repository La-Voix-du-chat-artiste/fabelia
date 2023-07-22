Rails.application.routes.draw do
  root to: 'homes#show'

  post '/replicate/webhook', to: 'replicate/webhooks#event'
  post '/replicate/webhook/publish', to: 'replicate/webhooks#publish'

  resources :stories, only: %i[create] do
    scope module: :stories do
      resources :chapters, only: %i[create] do
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
end
