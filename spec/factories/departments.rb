FactoryBot.define do
  factory :department, class: Department do
    name { 'nome' }
    local { Faker::LordOfTheRings.location }
    email { Faker::Internet.unique.username }
    phone { Faker::PhoneNumber.phone_number }
    description { Faker::Lorem.paragraph }
    initials { Faker::Address.unique.country_code_long }
  end
end
