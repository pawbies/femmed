Rails.application.routes.draw do
  resources :medications, shallow: true do
    resources :medication_versions
  end

  resources :active_ingredients
  resources :labelers
  resources :categories
  resources :users

  resources :prescriptions do
    scope module: :prescription do
      resources :packs
      resources :doses
    end
    resource :routine
  end

  get "profile" => "users#profile"
  resource :session
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

  get "timeline" => "site#timeline"
  get "calendar" => "site#calendar"
  get "admin"    => "site#admin"

  scope "/transfer", module: :transfer do
    resource :export
  end

  post "push_subscriptions" => "push_subscriptions#create"
  delete "push_subscriptions" => "push_subscriptions#destroy"
end
