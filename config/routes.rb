StartupShopKC::Application.routes.draw do
  get 'home/index', as: 'home'
  root :to => 'home#index'
  get 'signin' => 'sessions#new', as: 'signin'
  post 'signin' => 'sessions#create'
  get 'signout' => 'sessions#destroy'
  get 'signup' => 'users#new', as: 'signup'
  resources :users
end
