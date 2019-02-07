require './lib/faker/csv'
FactoryBot.define do
  factory :document do
    kind { Document.kinds.values.sample }
    description { Faker::Lorem.sentence(10) }
    activity { Faker::Lorem.sentence(10) }
    participants { Faker::CSV.participants }

    after(:build) do |dc|
      dc.users << create(:user)
      dc.users_documents.each { |ud| ud.subscription = true }
    end
    

    trait :without_subscription do
      after(:build) do |dc|
        dc.users << create(:user)
        dc.users_documents.each { |ud| ud.subscription = false }
      end
    end
  end
end
