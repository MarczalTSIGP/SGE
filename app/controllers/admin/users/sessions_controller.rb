class Admin::Users::SessionsController < Devise::SessionsController
  prepend_before_action :require_no_authentication, only: [:cancel]

  layout 'admin/users/sessions/layouts/application'

  def create
    super do |resource|
      unless resource.active?
        sign_out
        flash[:notice] = I18n.t('devise.failure.locked')
        redirect_to new_user_session_path
        return
      end
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    admin_root_path
  end
end

