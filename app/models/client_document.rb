class ClientDocument < ApplicationRecord
  belongs_to :client
  belongs_to :document

  accepts_nested_attributes_for :client, :reject_if => :all_blank
  validates :hours, presence: true
  validates :document, uniqueness: { scope: :client, message: 'Participante já adicionado' }

end
