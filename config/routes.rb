Casenexus::Application.routes.draw do

  # Static Pages
  root to: 'static_pages#home'
  match '/about', to: 'static_pages#about'

  # Users
  resources :users, only: [:index, :show, :new, :create, :edit, :update]
  match '/signup', to: 'users#new'
  match '/tooltip', to: 'users#tooltip'
  match '/get_latlng', to: 'users#get_latlng'

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
  resources :cases, only: [:index, :show, :new, :create, :analysis] do
    get "analysis", on: :collection
  end
  match '/get_radar_analysis', to: 'cases#get_radar_analysis'


  # Notifications
  resources :notifications, only: [:index, :show, :create]

  # Roulette
  resources :roulette, only: [:index]
  match '/get_item', to: 'roulette#item'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
