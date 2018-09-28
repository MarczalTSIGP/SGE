# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
department_list = [
    ["derak", "deraj", "", "p16", "00000000000", "a@k.com"],
    ["deral", "derai", "", "p16", "00000000000", "a@l.com"],
    ["deram", "derah", "", "p16", "00000000000", "a@m.com"],
    ["deran", "derag", "", "p16", "00000000000", "a@n.com"],
    ["derao", "deraf", "", "p16", "00000000000", "a@o.com"],
    ["derap", "derae", "", "p16", "00000000000", "a@p.com"],
    ["deraq", "derad", "", "p16", "00000000000", "a@q.com"],
    ["derar", "derac", "", "p16", "00000000000", "a@r.com"],
    ["deras", "derab", "", "p16", "00000000000", "a@s.com"],
    ["derat", "deraa", "", "p16", "00000000000", "a@t.com"]
]

department_list.each do |name, initials, description, local, phone, email|
  Department.create(name: name, initials: initials,
                    description: description, local: local, phone: phone, email: email)
end

user_list = [
    'Ronaldo Leite Carvalho',
    'Leonardo Campos de Souza',
    'João Machado Batista',
    'Débora Miranda Maldonado',
    'Bianca Luz Yoshimura',
    'Rita Siqueira Chagas'
]

user_list.each do |name|
  User.create(name: name)
end

role_list = [
    ["Chefe de Departamento", :manager],
    ["Coordenador de Evento", :event_coordinator],
    ["Membro do Departamento", :member]
]

role_list.each do |name, flag|
  Role.create(name: name, flag: flag)
end

# department_role_list = [
#     [Department.first, User.first, Role.manager],
#     [Department.first, User.last, Role.coordinator]
# ]
#
# department_role_list.each do |department, user, role|
#   DepartmentRole.create(department: department, user: user, role: role)
# end
