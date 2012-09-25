StartupShopKC::Application.routes.draw do
  get 'home/index', as: 'home'
  root :to => 'home#index'
  
  get 'search'          => 'home#search', as: 'search'
  post 'search'         => 'home#search', as: 'search'
  get 'update_map'      => 'home#update_map'
  get 'signin'          => 'sessions#new', as: 'signin'
  post 'signin'         => 'sessions#create'
  get 'signout'         => 'sessions#destroy'
  get 'signup'          => 'users#new', as: 'signup'
  get 'my_account'      => 'users#my_account', as: 'my_account'
  get 'charge'          => 'users#charge'
  post 'update_card'    => 'users#update_card'
  get 'locations_by_category' => 'locations#locations_by_category'
  match 'confirm_email/:code' => 'users#confirm_email'
  
  match 'auth/:provider/callback', to: 'sessions#provider'
  match 'auth/failure', to: redirect('/')

  resources :users
  resources :locations
  resources :events
  
  namespace :admin do
    get 'dashboard/index'
    get 'first_admin' => 'dashboard#first_admin', as: 'first_admin'
    post 'create_first_admin' => 'dashboard#create_first_admin', as: 'create_first_admin'
    put 'update_user' => 'dashboard#update_user', as: 'update_user'
    get 'active_location' => 'dashboard#active_location'
    get 'location_filter' => 'dashboard#location_filter'
    get 'active_event' => 'dashboard#active_event'
    get 'event_filter' => 'dashboard#event_filter'
    get 'remove_twitter' => 'dashboard#remove_twitter'
    post 'update_cost' => 'dashboard#update_cost'
    post 'update_twitter' => 'dashboard#update_twitter'
    post 'import_locations' => 'dashboard#import_locations', as: 'import_locations'
    match "/" => "dashboard#index"
    root :to => "admin/dashboard#index"
  end
  
end
