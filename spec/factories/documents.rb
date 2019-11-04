FactoryBot.define do
  factory :document do
    title { 'MyString' }
    front { 'MyString' }
    back { 'MyString' }
    association :division, factory: :division
  end
end
