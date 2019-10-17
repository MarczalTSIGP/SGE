class Admin::BaseController < ActionController::Base
  before_action :authenticate_user!
  before_action :permission
  protect_from_forgery with: :exception

  include FlashMessage

  layout 'layouts/admin/application'

  def permission
    redirect_to staff_root_path unless current_user.admin?
  end
end
