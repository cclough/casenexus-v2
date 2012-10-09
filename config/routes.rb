Casenexus::Application.routes.draw do

  # Static Pages
  root to: 'static_pages#home'
  match '/about', to: 'static_pages#about'

  # Users
  resources :users, only: [:index, :show, :new, :create, :edit, :update]
  match '/signup', to: 'users#new'
  match '/tooltip', to: 'users#tooltip'
  match '/test', to: 'users#test'
  
  # match '/get_markers_within_viewport',  to: 'users#get_markers_within_viewport' # Switched off until lots of users

  # LinkedIn
  match '/auth/linkedin/callback', to: 'sessions#create'

  # Sessions
  resources :sessions, only: [:new, :create, :destroy]
  match '/signin', to: 'sessions#new'
  match '/signout',  to: 'sessions#destroy', via: :delete

  # Password Resets
  resources :password_resets, only: [:new, :create, :edit, :update]

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
  match '/get_item', to: 'roulette#item'

end