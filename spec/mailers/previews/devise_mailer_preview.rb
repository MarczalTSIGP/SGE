class DeviseMailerPreview < ActionMailer::Preview
  # Preview all emails at http://localhost:3000/rails/mailers
  def reset_password_instructions
    client = Client.create_with(name: Faker::Name.name,
                                ra: Time.now.to_i,
                                cpf: Faker::CPF.numeric,
                                password: '123456',
                                kind: Client.kinds.values.sample)
                   .find_or_create_by(email: 'client@utfpr.edu.br')

    token = client.send(:set_reset_password_token)
    Devise::Mailer.reset_password_instructions(client, token)
  end
end
