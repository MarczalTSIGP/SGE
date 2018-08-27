Rails.application.routes.draw do

  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}

  root to: 'home#index'

  namespace :admin do
    root to: 'home#index'
  end

  namespace :participants do
    root to: 'home#index'
  end


end
