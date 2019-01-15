# frozen_string_literal: true

class Participants::Clients::PasswordsController < Devise::PasswordsController
  layout 'participants/clients/layouts/session'
end
