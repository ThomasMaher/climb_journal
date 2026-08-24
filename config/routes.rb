Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "sessions#index"

  post "/login", to: "auth#create"
  delete "/logout", to: "auth#destroy"
  get "/user_status", to: "auth#user_status"

  resources :users, only: %i[ create ]
  get "/home_stats", controller: :users, action: :home_stats

  resources :boulders, only: %i[ index show create update ] do
    get "/user_boulder_data", action: :user_boulder_data
    get "/sessions", action: :sessions, on: :member
  end
  resources :sessions, only: %i[ index show create destroy ] do
    get "session_stats", controller: :sessions, action: :session_stats
  end
  resources :session_climbs, only: %i[ show destroy ]
end
