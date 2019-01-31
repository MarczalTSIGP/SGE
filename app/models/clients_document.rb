class ClientsDocument < ApplicationRecord
  belongs_to :document
  belongs_to :client

  validates :hours, presence: true
end
