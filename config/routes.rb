Rails.application.routes.draw do
  root to: 'homes#show'

  post '/replicate/webhook', to: 'replicate/webhooks#event'
  post '/replicate/webhook/publish', to: 'replicate/webhooks#publish'

  get '/sessions', to: redirect('/sessions/new')

  resource :sessions, only: %i[new create destroy]
  resources :password_resets, only: %i[new create edit update]

  # Public resources
  scope :p do
    get 's/:id', controller: 'public/stories', action: 'show', as: :public_story
  end

  resources :stories, only: %i[new create show update destroy] do
    scope module: :stories do
      resource :covers, only: %i[update]

      resources :chapters, only: %i[create show] do
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

        resource :private_keys, only: [] do
          get :ask_password
          post :reveal
        end
      end

      collection do
        resource :import_profiles, only: %i[new create]
      end
    end
  end

  resources :relays, except: :show do
    scope module: :relays do
      collection do
        resource :resets, only: :create, as: :relays_resets
      end
    end
  end

  resources :thematics, except: :show
  resources :characters, except: :show
  resources :places, except: :show
  resources :prompts, except: :show do
    member do
      post :archive
    end
  end

  resource :settings, only: %i[edit update]
  resolve('Setting') { [:settings] }
end
