Rails.application.routes.draw do

  root to: 'home#index'
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resources :my_resources, concerns: :paginatable
  #========================================
  # Admin area to user
  #========================================
  devise_for :users, controllers: { sessions: 'admin/users/sessions' }
  authenticate :user do
    namespace :admin do
      root to: 'home#index'
      resources :documents, constraints: { id: /[0-9]+/ }, concerns: :paginatable do
        resources :clients_documents, except: [:show, :index]
      end
      get 'documents/subscriptions',
          to: 'documents#subscriptions',
          as: 'users_documents_subscriptions'
      put 'documents/sign/:id', to: 'documents#sign', as: 'users_documents_sign'
      get 'documents/search/(:term)/(page/:page)',
          to: 'documents#index',
          as: 'documents_search',
          constraints: { term: %r{[^/]+} }
      resources :users, except: :destroy, constraints: { id: /[0-9]+/ }, concerns: :paginatable
      get 'users/search/(:term)/(page/:page)',
          to: 'users#index',
          as: 'users_search',
          constraints: { term: %r{[^/]+} }

      put 'users/disable/:id', to: 'users#disable', as: 'user_disable'
      put 'users/active/:id', to: 'users#active', as: 'user_active'
    end
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
