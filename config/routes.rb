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

      resources :departments, constraints: { id: /[0-9]+/ }, concerns: :paginatable do
        get '/members' => 'departments#members'
        post '/members' => 'departments#add_member'
        delete '/members/:user_id' => 'departments#remove_member', as: 'remove_member'
        resources :divisions do
          get '/members' => 'divisions#members'
          post '/members' => 'divisions#add_member'
          delete '/members/:user_id' => 'divisions#remove_member', as: 'remove_member'
        end
        get 'divisions/search/(:term)/(page/:page)',
            to: 'divisions#index',
            as: 'divisions_search',
            constraints: { term: %r{[^/]+} }
      end

      get 'departments/search/(:term)/(page/:page)',
          to: 'departments#index',
          as: 'departments_search',
          constraints: { term: %r{[^/]+} }
    end
  end

  as :user do
    get '/admin/edit',
        to: 'admin/devise/registrations#edit',
        as: 'admin_edit_user_registration'

    put '/admin',
        to: 'admin/devise/registrations#update',
        as: 'admin_user_registration'

    get '/staff/edit',
        to: 'staff/devise/registrations#edit',
        as: 'staff_edit_user_registration'

    put '/staff',
        to: 'staff/devise/registrations#update',
        as: 'staff_user_registration'
  end
  #========================================
  #========================================
  # Participant area to staff
  #========================================
  namespace :staff do
    root to: 'home#index'

    get '/divisions', to: 'divisions#index_responsible', as: 'divisions'
    resources :departments, constraints: { id: /[0-9]+/ }, only: [:index, :show, :edit, :update] do
      get '/members' => 'departments#members'
      post '/members' => 'departments#add_member'
      delete '/members/:user_id' => 'departments#remove_member', as: 'remove_member'

      resources :divisions do
        get '/members' => 'divisions#members'
        post '/members' => 'divisions#add_member'
        delete '/members/:user_id' => 'divisions#remove_member', as: 'remove_member'
      end

      get 'divisions/search/(:term)/(page/:page)',
          to: 'divisions#index',
          as: 'divisions_search',
          constraints: { term: %r{[^/]+} }
    end
  end
  #========================================
  # Participant area to client
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
