require 'active_support/concern'
module LoginAuthentication
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :arguable_opts

    private

    def arguable(opts = {})
      @arguable_opts = opts
    end
  end

  included do
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      column = @arguable_opts[:include]
      column = column.join("''")
      if (login = conditions.delete(:login))
        where(['lower(' + column + ') = :value OR lower(email) = :value',
               { value: login.downcase }]).first
      end
    end
  end
end
