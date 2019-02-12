require './lib/faker/cpf'

namespace :db do
  desc 'Erase and Fill database'
  task populate: :environment do
    [User].each(&:delete_all)

    User.create_with(name: 'Administrador',
                     username: 'admin',
                     registration_number: '0',
                     cpf: '05443678043',
                     admin: true, active: true,
                     password: '123456',
                     support: true).find_or_create_by(email: 'admin@utfpr.edu.br')

    100.times do |i|
      email = Faker::Internet.unique.email
      rn = 1_234_567 + i
      bol = [true, false]
      cpf = Faker::CPF.numeric
      User.create!(name: Faker::Name.name,
                   email: email,
                   username: email.split('@')[0],
                   registration_number: rn,
                   cpf: cpf,
                   admin: bol.sample, active: bol.sample,
                   password: '123456',
                   support: false)

      client = Client.create(name: Faker::Name.name,
                             ra: rn,
                             email: email,
                             cpf: cpf,
                             password: '123456',
                             kind: Client.kinds.values.sample)

      document = Document.create(description: Faker::Lorem.paragraphs,
                                 activity: Faker::Lorem.paragraphs,
                                 user_ids: [User.where(support: false).where(active: true).sample.id],
                                 participants: Faker::CSV.participants,
                                 kind: Document.kinds.values.sample)

      UsersDocument.update(UsersDocument.last.id,
                           subscription: [true, false].sample)

      ClientDocument.create(document_id: document.id,
                            client_id: client.id,
                            hours: Faker::Number.between(1, 10))
    end
  end
end
