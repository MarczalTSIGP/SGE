# frozen_string_literal: true

class Participants::Clients::SessionsController < Devise::SessionsController
  layout 'participants/clients/layouts/application'
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do |resource|
      unless resource.active?
        sign_out
        flash[:notice] = I18n.t('devise.failure.disabled')
        redirect_to new_client_session_path
        return
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  def after_sign_out_path_for(_resource_or_scope)
    new_client_session_path
  end

  def after_sign_in_path_for(_resource)
    participants_root_path
  end
end
