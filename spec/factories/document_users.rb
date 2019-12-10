FactoryBot.define do
  factory :document_users, class: DocumentUser do
    function { Faker::Lorem.word }
    association :document, factory: :document
    association :user, factory: :user
  end

  trait :signed do
    subscription { true }
    signature_datetime { Time.zone.now }
  end
end
