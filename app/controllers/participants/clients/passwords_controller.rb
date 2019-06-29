# frozen_string_literal: true

class Participants::Clients::PasswordsController < Devise::PasswordsController
  layout 'layouts/devise/session'

  protected

  def after_sending_reset_password_instructions_path_for(_resource_name)
    participants_root_path
  end
end
