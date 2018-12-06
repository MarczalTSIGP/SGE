class Participants::Clients::SessionsController < Devise::SessionsController
  layout 'participants/clients/layouts/application'

  protected

  def after_sign_out_path_for(_resource_or_scope)
    new_client_session_path
  end

  def after_sign_in_path_for(_resource)
    participants_root_path
  end
end
