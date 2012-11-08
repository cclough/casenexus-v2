Casenexus::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations', sessions: 'sessions' }

  # User dashboard
  match '/dashboard', to: 'dashboard#index', as: :dashboard

  # Account
  resource :account, controller: 'account' do
    get :complete_profile, on: :collection
    put :show_help, on: :member
  end

  # Members
  resources :members, only: [:index, :show] do
    get :tooltip, on: :member
    put :show_help, on: :member
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
  end

  # Site contacts
  match '/site_contact/create', to: 'site_contacts#create', as: :site_contact
  match '/feedback/create', to: 'site_contacts#feedback', as: :site_feedback

  # Roulette
  match '/roulette', to: 'roulette#index', as: :roulette
  match '/get_item', to: 'roulette#get_item', as: :item_roulette
  match '/get_request', to: 'roulette#get_request', as: :request_roulette

  # Static Pages
  match '/about', to: 'static_pages#about'
  match '/terms', to: 'static_pages#terms'

  match '/invited/:code', to: 'static_pages#home', as: :invitation_registration

  root to: 'static_pages#home'
end