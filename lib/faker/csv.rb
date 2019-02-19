require 'faker'
require 'csv'
module Faker
  class Faker::CSV
    class << self
      def participants
        ::CSV.generate do |csv|
          csv << %w[cpf horas]
          Client.all.each do |client|
            csv << [client.cpf, Faker::Number.between(1, 10)]
          end
        end
      end
    end
  end
end
