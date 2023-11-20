Rails.application.routes.draw do
  root "pages#home"

  resources :artworks do
    resources :images
  end

  scope :admin do
    resources :users
  end

  namespace :curator do
    resources :artworks, only: [:index, :show]
  end

  devise_for :users
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    delete "logout", to: "devise/sessions#destroy"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
end
