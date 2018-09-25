class User < ApplicationRecord
  has_many :department_roles, dependent: :destroy
end
