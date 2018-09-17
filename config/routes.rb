Rails.application.routes.draw do

  root to: 'home#index'
  devise_for :users, path: 'admin/users', controllers: {registrations: 'admin/users/registrations', sessions: 'admin/users/sessions'}
  namespace :admin do
    root to: 'home#index'

    get 'users/disabled', to: 'users/disabled#index'
    delete 'users/disabled/:id', to: 'users/disabled#destroy', as: 'user_destroy'
    put 'users/disabled/:id', to: 'users/disabled#update', as: 'user_update'
  end

  namespace :participants do
    root to: 'home#index'
  end

end
