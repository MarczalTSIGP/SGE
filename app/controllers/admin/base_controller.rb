class Admin::BaseController < ActionController::Base
  before_action :authenticate_user!

  protect_from_forgery with: :exception
  layout 'layouts/admin/application'
end
