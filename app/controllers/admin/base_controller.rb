class Admin::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'admin/layouts/application'
end
