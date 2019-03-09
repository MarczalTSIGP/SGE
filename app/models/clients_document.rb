require 'json'
class ClientsDocument < ApplicationRecord
  belongs_to :client
  belongs_to :document

  validates :client_id, presence: true
  validate :json_input_field
  validates :client_id, uniqueness: { scope: :document }

  def self.hash_participants(id)
    d = Document.find_by(id: id)
    activity = d.description.scan(/{hora_[0-9]*}/)
    activity.push(*d.activity.scan(/{hora_[0-9]*}/))
    activity_hash = []
    activity.each_index do |index, hash|
      activity_hash[index] = activity[index].delete!("{}")
    end
    activity_hash = Hash[*[activity_hash.collect { |item| [item, ""] }].flatten]
    activity_hash
  end

  private

  def json_input_field
    participant_hours_fields.each do |index, value|
      if value.blank? &&
          errors.add(:participant_hours_fields, "Hora "+I18n.t('errors.messages.blank'))
        return
      end
    end
  end
end
