# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create_with(name: 'Administrador',
                 user_name: 'admin',
                 registration_number: '1',
                 cpf: '05443678043',
                 admin: true, active: true,
                 password: '123456',
                 support: true).find_or_create_by(email: 'admin@utfpr.edu.br')