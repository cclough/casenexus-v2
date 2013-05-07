Casenexus::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations', sessions: 'sessions' }

  # Map
  match '/map', to: 'map#index', as: :map

  # Account
  resource :account, controller: 'account' do
    get :complete_profile, on: :collection
    get :edit_password, on: :member
    put :show_help, on: :member
    get :random_name, on: :collection
    get :delete, on: :member
  end

  # Members
  resources :members, only: [:index, :show] do
    get :tooltip, on: :member
    put :show_help, on: :member
    get :help_checkbox, on: :collection
    get :check_roulette, on: :collection
  end

  # match '/get_markers_within_viewport',  to: 'users#get_markers_within_viewport' # Switched off until lots of users

  # Friendships
  resources :friendships, path: 'contacts', except: [:edit, :update] do
    member do
      put :accept
      put :reject
      put :block
      put :unblock
    end
    collection do
      get :requests
      get :invites
      get :blocked
    end
  end

  # Invitations
  resources :invitations, except: [:edit, :update]


  # Cases
  resources :cases, only: [:index, :show, :new, :create, :update] do
    get :analysis, on: :collection
  end

  # Notifications
  resources :notifications, only: [:index, :show, :create] do
    put :read, on: :member
    get :history, on: :collection
  end

  # Library
  resources :books, only: [:index, :show] do
    resources :comments, only: [:index, :new, :create]
  end

  # get "comments/index"
  # get "comments/new"

  # Viewer

  resources :console, only: [:index] do
    get :pdfjs, on: :collection
    get :select, on: :collection
  end

  # Map
  match '/library', to: 'books#index', as: :library

  # Summary

  match '/summary', to: 'summary#index', as: :summary

  # Site contacts
  match '/site_contact/create_contact', to: 'site_contacts#create_contact', as: :site_contact
  match '/site_contact/create_bug', to: 'site_contacts#create_bug', as: :site_bug

  # Roulette
  match '/roulette', to: 'roulette#index', as: :roulette
  match '/get_item', to: 'roulette#get_item', as: :item_roulette
  match '/get_request', to: 'roulette#get_request', as: :request_roulette

  # Events
  resources :events do
    get :ics, on: :collection
  end

  # Static Pages
  match '/about', to: 'static_pages#about'
  match '/terms', to: 'static_pages#terms'

  match '/invited/:code', to: 'static_pages#home', as: :invitation_registration

  root to: 'static_pages#home'
end