FactoryBot.define do


  factory :user do
    name "test"
    username "test"
    email "test@test.com"
    cpf "12345678901234"
    registration_number "123456"
    password "123456"
    password_confirmation "123456"
    status true
  end
end
