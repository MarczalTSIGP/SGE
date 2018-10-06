User.create_with(name: 'Administrador',
                 username: 'admin',
                 registration_number: '123456',
                 cpf: '05443678043',
                 admin: true, active: true,
                 password: '123456',
                 support: true).find_or_create_by(email: 'admin@utfpr.edu.br')
