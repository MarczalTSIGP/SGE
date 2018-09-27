Rails.application.routes.draw do

  root to: 'home#index'

#========================================
# Admin area to user
#========================================
  devise_for :users, controllers: {sessions: 'admin/users/sessions'}
  authenticate :user do
    namespace :admin do
      root to: 'home#index'
      resources :registrations, path: 'users/registration', module: 'users',
                      as: :user_registration, except: :destroy

      delete 'users/registration/disable/:id', to: 'users/registrations#disable', as: 'user_disable'
      put 'users/registration/active/:id', to: 'users/registrations#active', as: 'user_active'
    end
  end
#========================================


  namespace :participants do
    root to: 'home#index'
  end

end