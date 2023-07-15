Rails.application.routes.draw do
  root to: 'homes#show'

  resources :stories, only: :create
end
