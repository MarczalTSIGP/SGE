# frozen_string_literal: true

class Admin::Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  prepend_before_action :require_no_authentication, only: [:cancel]

  # POST /resource/sign_in
  def create
    if (current_user.try(:active?))
      super
    else
      redirect_to new_user_session_path, notice: 'Sua conta foi desativada'
    end
  end

  #DELETE /resource/sign_out
  def destroy
    super
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

end
