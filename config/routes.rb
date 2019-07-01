Rails.application.routes.draw do
  root to: 'home#index'
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resources :my_resources, concerns: :paginatable
  #========================================
  # Admin area to user
  #========================================
  devise_for :users, controllers: { sessions: 'admin/devise/sessions' }
  authenticate :user do
    namespace :admin do
      root to: 'home#index'
      resources :users, except: :destroy, constraints: { id: /[0-9]+/ }, concerns: :paginatable
      get 'users/search/(:term)/(page/:page)',
          to: 'users#index',
          as: 'users_search',
          constraints: { term: %r{[^/]+} }

      put 'users/disable/:id', to: 'users#disable', as: 'user_disable'
      put 'users/active/:id', to: 'users#active', as: 'user_active'
    end
  end

  as :user do
    get '/admin/edit',
        to: 'admin/devise/registrations#edit',
        as: 'edit_user_registration'

    put '/admin',
        to: 'admin/devise/registrations#update',
        as: 'user_registration'
  end
  #========================================

  #========================================
  # Participant area to user
  #========================================
  devise_for :clients, path: 'participants', controllers:
      { passwords: 'participants/clients/passwords',
        registrations: 'participants/clients/registrations',
        sessions: 'participants/clients/sessions' }
  authenticate :client do
    namespace :participants do
      root to: 'home#index'
    end
  end
end
