require './lib/faker/cpf'

FactoryBot.define do
  factory :client, class: Client do
    name { 'nome' }
    cpf { Faker::CPF.numeric }
    sequence(:email) { |n| "participante#{n}@participante.com" }
    alternative_email { 'alternative@gmail.com' }
    kind { Client.kinds.values.sample }
    password { '123456' }
    password_confirmation { '123456' }

    trait :inactive do
      active { false }
    end
  end
end
