Casenexus::Application.routes.draw do

  root to: 'static_pages#home'

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations', sessions: 'sessions' }

  # Pusher
  post 'pusher/auth'

  # Online user panel
  match '/online_user_item', to: 'application#online_user_item'

  # Static Pages
  match '/about', to: 'static_pages#about'
  match '/terms', to: 'static_pages#terms'

  match '/invited/:code', to: 'static_pages#home', as: :invitation_registration


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
    get :mouseover, on: :member
    get :show_modals, on: :member
    put :show_help, on: :member
    get :help_checkbox, on: :collection
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
  resources :cases, only: [:index, :show, :new, :create] do
    get :analysis, on: :collection
  end

  # Notifications
  resources :notifications, only: [:index, :show, :create] do
    put :read, on: :member
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
  end
  match 'console/sendpdf' => 'console#sendpdf', :as => :sendpdf
  match 'console/skypebutton' => 'console#skypebutton', :as => :skypebutton

  # Map
  match '/library', to: 'books#index', as: :library

  # Summary

  match '/summary', to: 'summary#index', as: :summary

  # Site contacts
  match '/site_contact/create_contact', to: 'site_contacts#create_contact', as: :site_contact

  # Events
  resources :events do
    get :ics, on: :collection
    get :user_timezone, on: :collection
  end

end