
Rails.application.routes.draw do
  resources :settings
  resources :medications, shallow: true do
    resources :medication_versions do
      resources :prescriptions, only: %i[ new create ]
    end
  end

  resources :prescriptions, except: %i[ new create ] do
    resources :packs
    resources :doses
  end

  resources :active_ingredients
  resources :labelers
  resource :assistent_talks
  resources :users
  get "profile" => "users#profile"
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "site#index"

  get "landing" => "site#landing"
  get "about" => "site#about"

  get "legal/imprint", as: :imprint
  get "legal/terms-of-service", as: :terms_of_service
  get "legal/privacy", as: :privacy

  get "search" => "search#index"

  get "timeline" => "timeline#index"
  get "calendar" => "calendar#index"
end
