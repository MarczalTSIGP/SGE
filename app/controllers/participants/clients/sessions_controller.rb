class Participants::Clients::SessionsController < Devise::SessionsController
  layout 'participants/clients/layouts/application'

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

  protected

  def after_sign_out_path_for(_resource_or_scope)
    new_client_session_path
  end

  def after_sign_in_path_for(_resource)
    participants_root_path
  end
end
