# frozen_string_literal: true

class Admin::Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  prepend_before_action :authenticate_scope!, only: [:new, :create, :edit, :update, :destroy]

  prepend_before_action :require_no_authentication, only: [:cancel]

  def new
    if current_user.admin?
      super
    else
      redirect_to admin_root_path
    end
  end

  def create
    if current_user.admin?
      build_resource(sign_up_params)

      if resource.save
        flash[:notice] = "Usuário cadastrado com sucesso."
        redirect_to admin_users_disabled_path
      else
        super
      end
    end
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

  private

  def attributes
    return [:name, :username, :cpf, :registration_number, :active, :email, :password, :password_confirmation, :remember_me]
  end
end
