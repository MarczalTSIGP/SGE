FactoryBot.define do
  factory :user, class: User do
    name "cde"
    username "test@utfpr.edu.br"
    cpf "49503267080"
    alternative_email "teste@gmail.com"
    registration_number "123456"
    password "123456"
    password_confirmation "123456"
    active true
    admin false
  end
  factory :user_admin, class: User do
    name "test admin"
    username "test_admin@utfpr.edu.br"
    cpf "16590783268"
    registration_number "123457"
    password "123456"
    password_confirmation "123456"
    active true
    admin true
  end
  factory :user_inactive, class: User do
    name "abc"
    username "test2@utfpr.edu.br"
    cpf "99905883096"
    registration_number "123458"
    password "123456"
    password_confirmation "123456"
    active false
  end
  factory :user_invalid, class: User do
    name "test1"
    username "test1@gmail.com"
    cpf "12345678901"
    registration_number "123457"
    password "123456"
    password_confirmation "123456"
    active false
  end


end
