FactoryBot.define do
  factory :division, class: Division do
    sequence(:name) { |n| "nome#{n}" }
    description { Faker::Lorem.paragraph }
    association :department, factory: :department
  end
end
