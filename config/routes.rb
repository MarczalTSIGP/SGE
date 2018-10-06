Rails.application.routes.draw do

  root to: 'home#index'

  #========================================
  # Admin area to user
  #========================================
  devise_for :users, controllers: {sessions: 'admin/users/sessions'}
  authenticate :user do
    namespace :admin do
      root to: 'home#index'
      resources :users, except: :destroy
      get 'users/search/(:term)', to: 'users#index', as: 'users_search',  constraints: { term: /[^\/]+/}
      delete 'users/disable/:id', to: 'users#disable', as: 'user_disable'
      put 'users/active/:id', to: 'users#active', as: 'user_active'
    end
  end
  #========================================

  namespace :participants do
    root to: 'home#index'
  end
end
