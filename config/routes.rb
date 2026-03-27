Rails.application.routes.draw do
  resources :medications, shallow: true do
    resources :medication_versions
  end

  resources :active_ingredients
  resources :labelers
  resources :categories
  resources :forms
  resources :users

  resources :prescriptions do
    scope module: :prescriptions do
      resources :packs
      resources :doses
      resource :routine
      get "about" => "about#show"
    end
  end

  get "profile" => "users#profile"
  resource :session

  get "up" => "rails/health#show", as: :rails_health_check

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "pages/home#show"


  scope "/", module: :pages do
    get "timeline" => "timeline#show"
    get "calendar" => "calendar#show"
    get "admin"    => "admin#show"

    get "landing" => "landing#show"
    get "about"   => "about#show"
  end

  get "legal/imprint", as: :imprint
  get "legal/terms-of-service", as: :terms_of_service
  get "legal/privacy", as: :privacy

  get "search" => "search#index"

  scope "/transfer", module: :transfer do
    resource :export
  end

  post "push_subscriptions" => "push_subscriptions#create"
  delete "push_subscriptions" => "push_subscriptions#destroy"
end
