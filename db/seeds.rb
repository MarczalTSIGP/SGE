User.create_with(name: 'Administrador',
                 username: 'admin',
                 registration_number: '0000000',
                 cpf: '05443678043',
                 admin: true, active: true,
                 password: '123456',
                 support: true).find_or_create_by(email: 'admin@utfpr.edu.br')

User.create_with(name: 'Servidor',
                 username: 'servidor',
                 registration_number: '0000001',
                 cpf: '76150313034',
                 admin: false, active: true,
                 password: '123456',
                 support: true).find_or_create_by(email: 'servidor@utfpr.edu.br')

Client.create_with(name: 'Participante',
                   cpf: '36688844044',
                   email: 'participante@gmail.com',
                   kind: Client.kinds.values.sample,
                   password: '123456').find_or_create_by(email: 'participante@gmail.com')
roles = [
  ['Chefe de Departamento', :manager, true],
  ['Membro do Departamento', :member_department, true],
  ['Responsável da Divisão', :responsible, false],
  ['Membro da Divisão', :member_division, false]
]

roles.each do |name, identifier, department|
  Role.find_or_create_by!(name: name, identifier: identifier, department: department)
end
