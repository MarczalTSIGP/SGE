class Participants::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'participants/layouts/application'
end
