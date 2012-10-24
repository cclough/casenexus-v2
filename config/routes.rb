Casenexus::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # User dashboard
  match '/dashboard', to: 'dashboard#index', as: :dashboard
  match '/tooltip', to: 'dashboard#tooltip', as: :tooltip

  # Account
  resource :account, controller: 'account'

  # match '/get_markers_within_viewport',  to: 'users#get_markers_within_viewport' # Switched off until lots of users

  # Friendships
  resources :friendships, controller: 'friendships', :except => [:show, :edit] do
    get "requests", on: :collection
    get "invites", on: :collection
  end

  # Cases
  resources :cases, only: [:index, :show, :new, :create, :analysis, :update] do
    get "analysis", on: :collection
  end

  # Notifications
  resources :notifications, only: [:index, :show, :create]

  # Roulette
  resources :roulette, only: [:index]
  match '/item', to: 'roulette#item'
  match '/request', to: 'roulette#request'

  # Static Pages
  match '/about', to: 'static_pages#about'
  match '/terms', to: 'static_pages#terms'
  root to: 'static_pages#home'
end