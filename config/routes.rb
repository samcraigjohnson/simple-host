Rails.application.routes.draw do
  resources :newsletter_signups, only: :create
  root "home#index"
  get "pitr", to: "home#pitr"
  delete "pitr", to: "home#important_delete", as: :delete_info
  post "pitr", to: "home#create_info", as: :create_info

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
