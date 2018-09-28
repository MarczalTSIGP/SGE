class Role < ApplicationRecord
  has_many :department_users

  def self.manager
    find_by(:manager)
  end

  def self.envent_coordinator
    find_by(:event_coordinator)
  end
end
