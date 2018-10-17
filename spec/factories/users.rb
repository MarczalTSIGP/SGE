require './lib/faker/cpf'

FactoryBot.define do
  factory :user, class: User do
    name { 'nome' }
    cpf { Faker::CPF.numeric }
    sequence(:username) { |n| "username#{n}" }
    sequence(:registration_number) { |n| "123456#{n}" }
    alternative_email { "alternative@gmail.com" }
    password { "123456" }
    password_confirmation { "123456" }

    trait :inactive do
      active { false }
    end

    trait :admin do
      active { true }
    end
  end
end
