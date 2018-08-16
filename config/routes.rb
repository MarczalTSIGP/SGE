Rails.application.routes.draw do

  root to: 'home#index'

  namespace :admin do
    root to: 'home#index'
    resources :departments
  end

  namespace :participant do
    root to: 'home#index'
  end

end