StartupShopKC::Application.routes.draw do
  get 'home/index', as: 'home'
  root :to => 'home#index'
  get 'signin' => 'sessions#new', as: 'signin'
  get 'signup' => 'users#new', as: 'signup'
  resources :users
end
