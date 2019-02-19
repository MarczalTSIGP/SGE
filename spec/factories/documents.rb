require './lib/faker/csv'
FactoryBot.define do
  factory :document do
    kind { Document.kinds.values.sample }
    description { Faker::Lorem.sentence(10) }
    activity { Faker::Lorem.sentence(10) }

    after(:build) do |dc|
      dc.users << create(:user)
      dc.users_documents.each { |ud| ud.function = Faker::Lorem.word }
    end

    trait :subscription do
      after(:build) do |dc|
        dc.users << create(:user)
        dc.users_documents.each { |ud| ud.subscription = true, ud.function = Faker::Lorem.word }
      end
    end
  end
end
