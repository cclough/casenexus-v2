Casenexus::Application.routes.draw do

  # Rails Admin
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  ##### Devise
  devise_for :users, skip: :registrations, path_names: { :sign_in => 'signin', :sign_out => 'signout' }, :path => '', 
      controllers: { sessions: 'sessions' }

  # custom so doesn't include e.g. edit routes
  devise_scope :user do
    resource :registration,
      only: [:new, :create, :update],
      path: 'users',
      controller: 'registrations',
      as: :user_registration
  end

  authenticated :user do
    # root :to => "profile#index"
    match '/' => 'profile#index', :as => :root
  end

  unauthenticated :user do
    devise_scope :user do 
      get "/" => 'static_pages#home'
    end
  end

  # Pusher
  post 'pusher/auth'

  # Static Pages
  match '/terms', to: 'static_pages#terms'
  match '/invited/:code', to: 'static_pages#home', as: :invitation_registration

  # Map
  match '/map', to: 'map#index', as: :map

  # Profile
  match '/profile', to: 'profile#index', as: :root

  # Account
  resource :account, controller: 'account' do
    get :complete_profile, on: :collection
    get :edit_password, on: :member
    get :delete, on: :member
    # get :visitors, on: :collection
  end

  # Members
  resources :members, only: [:index]

  # Friendships
  resources :friendships, path: 'contacts', except: [:index, :new, :show, :edit, :update] do
    member do
      put :accept
      put :reject
      put :block
      put :unblock
      get 'delete_patch' => "friendships#destroy"
    end
    get "modal_friendship_req_form", on: :collection
  end

  # Invitations
  resources :invitations, except: [:edit, :update]

  # Cases
  resources :cases, only: [:show, :new, :create] do
    get :results, on: :collection
  end

  # Posts
  resources :posts, only: [:create,:show]
  
  # Notifications
  resources :notifications, only: [:index, :show, :create] do
    get :modal_message_form, on: :collection
    get :conversation, on: :collection
    get :notify, on: :member
    get :menu, on: :collection
  end

  # Tagging
  get 'questions/tags/:tag', to: 'questions#index', as: :question_tag
  get 'books/tags/:tag', to: 'books#index', as: :book_tag

  # Library
  resources :books, only: [:index, :show] do
    get :show_small, on: :member
  end
  match '/library', to: 'books#index', as: :library

  # Comments
  resources :comments, except: [:delete, :index]

  # PDF Viewer
  resources :console, only: [:index] do
    get :pdfjs, on: :collection
  end
  match 'console/sendpdf' => 'console#sendpdf', :as => :sendpdf
  match 'console/sendpdfbutton' => 'console#sendpdfbutton', :as => :sendpdfbutton
  match 'console/skypebutton' => 'console#skypebutton', :as => :skypebutton

  # Site contacts
  match '/site_contacts/create', to: 'site_contacts#create', as: :site_contact

  # Headsups
  match '/headsups/create', to: 'headsups#create', as: :headsups

  # Events
  resources :events, except: [:index,:show] do
    get :ics, on: :collection
    get :user_timezone, on: :collection
  end

  # Questions # COMMENTED FOR LAUNCH
    # resources :questions do
    # end

    # Answers
    # resources :answers, only: [:create, :update, :show, :destroy, :edit] do
    # end

  # Votes # COMMENTED FOR LAUNCH
    # resources :votes, only: [:destroy]
    # match '/votes/control', to: 'votes#control'
    # match '/votes/control_comments', to: 'votes#control_comments'
    # match '/votes/up', to: 'votes#up'
    # match '/votes/down', to: 'votes#down'
end