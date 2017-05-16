# frozen_string_literal: true

Rails.application.routes.draw do
  root 'categories#index'
  devise_for :users
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  resources :users, only: %i[show update edit] do
    member do
      get :following
      get :searches
    end
  end
  get '/settings', to: 'users#edit'
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
      patch 'update_email'
    end
  end
  resources :tickets
  resources :categories, only: %i[index show]
  resources :ticket_activations, only: [:edit]
  resources :relationships, only: %i[create destroy]
  resources :searches, only: %i[new show update create destroy] do
    member do
      get :new_tickets
    end
  end

  namespace :admin do
    root to: 'admin#index'
    resources :users, only: %i[index show destroy] do
      member do
        get :following
        get :searches
      end
    end
    resources :tickets, only: %i[index show destroy]
    resources :categories
    resources :relationships, only: %i[index destroy]
    resources :searches, only: %i[index show destroy] do
      member do
        get :new_tickets
      end
    end
  end
end
