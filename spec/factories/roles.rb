FactoryBot.define do
  factory :role, class: Role do
    trait :manager do
      name { 'Chefe de Departamento' }
      identifier { 'manager' }
    end

    trait :member do
      name { 'Membro do Departamento' }
      identifier { 'member' }
    end
  end
end
