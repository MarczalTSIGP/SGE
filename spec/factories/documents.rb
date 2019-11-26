FactoryBot.define do
  factory :document do
    title { 'MyString' }
    front { 'MyString' }
    back { 'MyString' }
    variables { "{name:'teste'}" }
    association :division, factory: :division
  end
end
