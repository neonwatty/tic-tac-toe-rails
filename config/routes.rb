Rails.application.routes.draw do
  resource :registration, only: [:new, :create]
  resource :session
  resources :passwords, param: :token
  resource :single_player_game, only: [:new, :show, :create]
  resources :two_player_games, only: [:new, :create, :show] do
    post 'move', on: :member
    post 'join', on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "sessions#new"

  mount ActionCable.server => '/cable'
end
