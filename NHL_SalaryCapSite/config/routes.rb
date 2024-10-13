Rails.application.routes.draw do
  devise_for :admins
  authenticate :admin do
    mount Motor::Admin => '/admin'
  end

  namespace :api do
    post 'import_contracts', to: 'imports#import_contracts'
  end
  
  get 'home/index'
  get 'players/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :players, param: :slug
  root 'home#index'

  resources :teams, param: :code  # Use code as a parameter

  # Defines the root path route ("/")
  # root "posts#index"
end
