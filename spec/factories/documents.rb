FactoryBot.define do
  factory :document do
    title { 'MyString ' }
    front { 'MyString {name}' }
    back { 'MyString' }
    variables { '{"name":"name"}' }
    association :division, factory: :division
  end

  trait :request_signature do
    request_signature { true }
  end
end
