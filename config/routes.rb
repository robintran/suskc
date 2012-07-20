StartupShopKC::Application.routes.draw do
  get 'home/index', as: 'home'
  root :to => 'home#index'
  get 'signin' => 'sessions#new', as: 'signin'
  post 'signin' => 'sessions#create'
  get 'signout' => 'sessions#destroy'
  get 'signup' => 'users#new', as: 'signup'
  get 'update_map' => 'home#update_map'
  match 'confirm_email/:code' => 'users#confirm_email'
  
  resources :users
  resources :locations
  
  namespace :admin do
    get 'dashboard/index'
    get 'first_admin' => 'dashboard#first_admin', as: 'first_admin'
    post 'create_first_admin' => 'dashboard#create_first_admin', as: 'create_first_admin'
    put 'update_user' => 'dashboard#update_user', as: 'update_user'
    match "/" => "dashboard#index"
    root :to => "admin/dashboard#index"
  end
  
end
