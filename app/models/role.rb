class Role < ApplicationRecord
  has_many :department_roles, dependent: :destroy

  def self.manager
    find_by_flag('manager')
  end

  def self.coordinator
    find_by_flag('event')
  end
end
