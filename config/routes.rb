Casenexus::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations', sessions: 'sessions' }

  # User dashboard
  match '/dashboard', to: 'dashboard#index', as: :dashboard

  # Account
  resource :account, controller: 'account' do
    get :complete_profile, on: :collection
  end

  # Members
  resources :members, only: [:index, :show] do
    get :tooltip, on: :member
    # TODO: Friendship actions should go on members
    # so it would be /members/:id/request_friendship and so on
    # we can use friendly_id to avoid showing the user id and it rocks
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

  # Cases
  resources :cases, only: [:index, :show, :new, :create, :update] do
    get :analysis, on: :collection
  end

  # Notifications
  resources :notifications, only: [:index, :show, :create]

  # Roulette
  match '/roulette', to: 'roulette#index', as: :roulette
  match '/get_item', to: 'roulette#get_item', as: :item_roulette
  match '/get_request', to: 'roulette#get_request', as: :request_roulette

  # Static Pages
  match '/about', to: 'static_pages#about'
  match '/terms', to: 'static_pages#terms'
  root to: 'static_pages#home'
end