FactoryBot.define do
  factory :role, class: Role do
    trait :manager do
      name { 'Chefe de Departamento' }
      identifier { 'manager' }
      department { true }
    end

    trait :member_department do
      name { 'Membro do Departamento' }
      identifier { 'member_department' }
      department { true }
    end

    trait :responsible do
      name { 'Responsavel da Divisão' }
      identifier { 'responsible' }
      department { false }
    end

    trait :member_division do
      name { 'Membro da Divisão' }
      identifier { 'member_division' }
      department { false }
    end
  end
end
