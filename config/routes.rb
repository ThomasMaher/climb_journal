Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "sessions#index"

  resources :users, only: [] do
    resource "home_stats.json.jbuilder", controller: :users, action: :home_stats
    resources :sessions, only: %i[index show create destroy] do
      resources :session_climbs, only: %i[index]
    end
  end
  resources :boulders, only: %i(index show create destroy)
end
