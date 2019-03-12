require './lib/faker/cpf'

FactoryBot.define do
  factory :client, class: Client do
    name { Faker::Name.unique.name      }
    cpf { Faker::CPF.numeric }
    sequence(:email) { |n| "participante#{n}@participante.com" }
    sequence(:alternative_email) { |n| "alternative#{n}@gmail.com" }
    kind { Client.kinds.values.sample }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
