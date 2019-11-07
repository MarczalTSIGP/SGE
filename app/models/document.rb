class Document < ApplicationRecord
  belongs_to :division
  has_many :document_users, dependent: :destroy
  has_many :users, through: :document_users, class_name: 'User'

  validates :title, :front, :back, :division, :variables, presence: true

  attr_accessor :variable_json

  accepts_nested_attributes_for :document_users, allow_destroy: true

  def self.search(search)
    if search
      where('unaccent(title) ILIKE unaccent(?)',
            "%#{search}%").order('title ASC')
    else
      order('title ASC')
    end
  end
end
