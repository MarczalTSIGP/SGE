FactoryBot.define do
  factory :division_users, class: DivisionUser do
    association :user, factory: :user
    association :division, factory: :division
    association :role, factory: [:role, :responsible]
  end
end
