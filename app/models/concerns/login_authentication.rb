require 'active_support/concern'
module LoginAuthentication
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :arguable_opts

    private

    def arguable(opts = {})
      @arguable_opts = opts
      @arguable_opts = @arguable_opts[:include].join("''")
    end
  end

  included do
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login).downcase
      if login.include?('@')
        find_by(email: login)
      elsif @arguable_opts == 'username'
        find_by(username: login)
      elsif @arguable_opts == 'cpf'
        find_by(cpf: login)
      end
    end
  end
end
