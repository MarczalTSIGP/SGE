FactoryBot.define do
  factory :document_clients, class: DocumentClient do
    cpf { Faker::CPF.numeric }
    association :document, factory: :document
    key_code { SecureRandom.urlsafe_base64(nil, false) }
    information { JSON.parse('{"name": "' + Faker::Artist::name + '"}') }
  end
end
