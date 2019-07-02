# frozen_string_literal: true

class Participants::Clients::RegistrationsController < Devise::RegistrationsController
  layout :choose_layout
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    super
  end

  def update
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  def after_sign_up_path_for(_resource)
    participants_root_path
  end

  def after_update_path_for(*)
    edit_client_registration_path
  end

  def attributes
    [:name, :cpf, :alternative_email, :email, :password,
     :password_confirmation, :kind]
  end

  def choose_layout
    return 'layouts/participants/application' if client_signed_in?

    'layouts/devise/sign_up'
  end
end
