User.create_with(name: 'Administrador',
                 username: 'admin',
                 registration_number: '0000000',
                 cpf: '05443678043',
                 admin: true, active: true,
                 password: '123456',
                 support: true).find_or_create_by(email: 'admin@utfpr.edu.br')

roles = [
    ["Chefe de Departamento", :manager],
    ["Membro do Departamento", :member]
]

roles.each do |name, identifier|
  Role.find_or_create_by!(name: name, identifier: identifier)
end
