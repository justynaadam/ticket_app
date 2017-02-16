Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  resources :users, only: [:show, :update, :edit]
  get '/settings', to: 'users#edit'
  resource :user, only: [:edit] do
  collection do
    patch 'update_password'
    patch 'update_email'
  end
  end
end
