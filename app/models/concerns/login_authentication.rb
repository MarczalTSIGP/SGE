require 'active_support/concern'
module LoginAuthentication
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :login_method

    private

    def also_login_by(login_method)
      @login_method = login_method
    end
  end

  included do
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login).downcase
      conditions = { email: login }

      conditions = { @login_method => login } unless login.include?('@')

      find_by(conditions)
    end
  end
end
