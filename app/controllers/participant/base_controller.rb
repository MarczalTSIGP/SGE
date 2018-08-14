class Participant::BaseController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'participant/layouts/application'
end
