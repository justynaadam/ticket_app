Rails.application.routes.draw do
  get 'searches/new'

  get 'searches/show'

  get 'categories/index'

  devise_for :users
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  resources :users, only: [:show, :update, :edit, :destroy]
  get '/settings', to: 'users#edit'
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
      patch 'update_email'
    end
  end
  resources :users do
    member do
      get :following
    end
  end
  namespace :admin do
    root to: "admin#index"
    resources :users, only: [:index, :show, :destroy]
  end
  resources :tickets
  resources :categories
  resources :ticket_activations, only: [:edit]
  resources :relationships, only: [:create, :destroy]
  resources :searches, only: [:new, :show, :create, :destroy]
  root 'categories#index'
end
