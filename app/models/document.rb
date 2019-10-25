class Document < ApplicationRecord
  belongs_to :division

  validates :title, :front, :back, :division, presence: true

  def self.search(search)
    if search
      where('unaccent(title) ILIKE unaccent(?)',
            "%#{search}%").order('title ASC')
    else
      order('title ASC')
    end
  end
end
