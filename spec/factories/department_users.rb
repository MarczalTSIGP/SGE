FactoryBot.define do
  factory :department_users, class: DepartmentUser do
    association :user, factory: :user
    association :department, factory: :department
    association :role, factory: [:role, :manager]
  end
end
