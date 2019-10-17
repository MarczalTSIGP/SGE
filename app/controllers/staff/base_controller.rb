class Staff::BaseController < ActionController::Base
  before_action :authenticate_user!

  protect_from_forgery with: :exception

  include FlashMessage

  layout 'layouts/staff/application'
end
