require './lib/faker/cpf'

module Populate
  class Clients
    def populate
      create_clients
    end

    private

    def create_clients
      75.times do
        Client.create!(
          name: Faker::Name.name,
          email: Faker::Internet.unique.email,
          alternative_email: Faker::Internet.email,
          cpf: Faker::CPF.numeric,
          kind: Client.kinds.values.sample,
          password: '123456'
        )
      end
    end
  end
end
