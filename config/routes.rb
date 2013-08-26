Casenexus::Application.routes.draw do

  root to: 'static_pages#home'

  # Rails Admin
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  # Devise
  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations', sessions: 'sessions' }

  # Pusher
  post 'pusher/auth'

  # Online panel
  resources :onlinepanel, only: [:index, :show] do
    get :container, on: :collection
  end

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
    get :visitors, on: :collection
  end

  # Members
  resources :members, only: [:index, :show] do
    get :mouseover, on: :member
    get :show_infobox, on: :member
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
      get 'delete_patch' => "friendships#destroy"
    end
    collection do
      get :requests
      get :invites
      get :blocked
    end
    get "modal_friendship_req_form", on: :collection
  end

  # Invitations
  resources :invitations, except: [:edit, :update]

  # Votes
  resources :votes, only: [:destroy]
  match '/votes/control', to: 'votes#control'
  match '/votes/up', to: 'votes#up'
  match '/votes/down', to: 'votes#down'

  # Cases
  resources :cases, only: [:index, :show, :new, :create] do
    get :analysis, on: :collection
  end

  # Posts
  resources :posts, only: [:create]
  
  # Notifications
  resources :notifications, only: [:index, :show, :create] do
    put :read, on: :member
    get :modal_message_form, on: :collection
    get :conversation, on: :collection
    get :popup, on: :member
    get :menu, on: :collection
  end

  # Questions
  resources :questions do
  end

  # Answers
  resources :answers, only: [:create, :update, :show, :destroy, :edit] do
  end

  # Tagging
  get 'questions/tags/:tag', to: 'questions#index', as: :question_tag
  get 'books/tags/:tag', to: 'books#index', as: :book_tag
  # Library
  resources :books, only: [:index, :show] do
    get :show_small, on: :member
  end

  # Comments
  resources :comments

  # PDF Viewer
  resources :console, only: [:index] do
    get :pdfjs, on: :collection
  end
  match 'console/sendpdf' => 'console#sendpdf', :as => :sendpdf
  match 'console/sendpdfbutton' => 'console#sendpdfbutton', :as => :sendpdfbutton
  match 'console/skypebutton' => 'console#skypebutton', :as => :skypebutton

  # Map
  match '/library', to: 'books#index', as: :library

  # Site contacts
  match '/site_contact/create_contact', to: 'site_contacts#create_contact', as: :site_contact

  # Events
  resources :events, except: [:show] do
    get :ics, on: :collection
    get :user_timezone, on: :collection
    get :calendar, on: :collection
  end

end