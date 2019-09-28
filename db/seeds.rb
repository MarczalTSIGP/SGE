User.create_with(name: 'Administrador',
                 username: 'admin',
                 registration_number: '0000000',
                 cpf: '05443678043',
                 admin: true, active: true,
                 password: '123456',
                 support: true).find_or_create_by(email: 'admin@utfpr.edu.br')

roles = [
  ['Chefe de Departamento', :manager, true],
  ['Membro do Departamento', :member_department, true],
  ['Responsavel da Divisão', :responsible, false],
  ['Membro da Divisão', :member_division, false]
]

roles.each do |name, identifier, department|
  Role.find_or_create_by!(name: name, identifier: identifier, department: department)
end
