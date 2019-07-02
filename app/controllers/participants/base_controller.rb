class Participants::BaseController < ActionController::Base
  before_action :authenticate_client!

  protect_from_forgery with: :exception
  layout '/layouts/participants/application'
end
