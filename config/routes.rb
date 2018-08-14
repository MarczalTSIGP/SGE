Rails.application.routes.draw do

  root to: 'home#index'

  namespace :admin do
    root to: 'home#index'
    resources :department
  end

  namespace :participant do
    root to: 'home#index'
  end

end
