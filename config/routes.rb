Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"

  # User profile routes
  resource :profile, only: [ :show, :edit, :update ]

  # Authentication routes
  resource :session, only: [ :new, :create, :destroy ]
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"

  # Product routes
  resources :products, only: [ :index, :show ] do
    resources :reviews, only: [ :create ]
  end

  # Cart and orders
  resource :cart, only: [ :show, :update, :destroy ]
  post "cart/add/:product_id", to: "carts#add", as: :add_to_cart
  delete "cart/remove/:product_id", to: "carts#remove", as: :remove_from_cart

  resources :orders, only: [ :create, :show, :index ]

  # Routes for Stripe Checkout
  resource :checkout, only: [ :create ]
  get "checkout/success", to: "checkouts#success"
  get "checkout/cancel", to: "checkouts#cancel"

  # Route for Stripe Webhooks
  post "webhooks/stripe", to: "webhooks#stripe"

  # Seller dashboard
  namespace :seller do
    root "dashboard#index"
    resources :products do
      collection do
        get :discarded
      end
      member do
        patch :restore
      end
    end
    resources :orders, only: [ :index, :show, :update ]
    resources :reviews, only: [ :index ]
  end

  # Admin dashboard
  namespace :admin do
    root "dashboard#index"
    resources :users
    resources :products
    resources :orders, only: [ :index, :show, :update ]
    resources :categories do
      collection do
        get :discarded
      end
      member do
        patch :restore
      end
    end
  end
end
