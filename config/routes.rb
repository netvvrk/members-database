Rails.application.routes.draw do
  root "main#index"
  get "/artwork/:id", to: "main#show", as: "public_artwork"

  resources :artworks do
    member do
      patch :move_artwork
    end    
    resources :images do
      member do
        patch :move_image
      end
    end
  end

  resources :profiles, only: [:edit, :show, :update]
  resources :artists, only: :show

  scope :admin do
    resources :users do
      member do
        get :login_as
        get :send_welcome_email
      end
    end
  end

  devise_for :users
  devise_scope :user do
    get "login", to: "devise/sessions#new"
    delete "logout", to: "devise/sessions#destroy"
  end

  post "webhook/chargebee", to: "webhook#chargebee"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
end
