Rails.application.routes.draw do

  root to: 'home#index'

  namespace :admin do
    root to: 'home#index'
    resources :departments do

      get '/members' => 'department_users#index'
      delete '/members/:id' => 'department_users#destroy', as: 'destroy_member'
      post '/add-manager' => 'department_users#add_manager'
      post '/add-coordinator-event' => 'department_users#add_coordinator_event'
    end
  end

  namespace :participants do
    root to: 'home#index'
  end

end