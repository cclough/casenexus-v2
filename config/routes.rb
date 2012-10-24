Casenexus::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # User dashboard
  match '/dashboard', to: 'dashboard#index', as: :dashboard

  # Account
  resource :account, controller: 'account'

  # Members
  resources :members do
    get :tooltip, on: :member
  end

  # match '/get_markers_within_viewport',  to: 'users#get_markers_within_viewport' # Switched off until lots of users

  # Friendships
  # TODO: Update friendships module
  resources :friendships, controller: 'friendships', :except => [:show, :edit] do
    get "requests", on: :collection
    get "invites", on: :collection
  end

  # Cases
  resources :cases, only: [:index, :show, :new, :create, :update] do
    get "analysis", on: :collection
  end

  # Notifications
  resources :notifications, only: [:index, :show, :create]

  # Roulette
  match '/roulette', to: 'roulette#index', as: :roulette
  match '/item', to: 'roulette#item', as: :item_roulette
  match '/request', to: 'roulette#request', as: :request_roulette

  # Static Pages
  match '/about', to: 'static_pages#about'
  match '/terms', to: 'static_pages#terms'
  root to: 'static_pages#home'
end