require './lib/faker/cpf'

module Populate
  class Users
    def initialize
      @rn = 1_234_567
      @bol = [true, false]
    end

    def populate
      create_users
    end

    private

    def create_users
      75.times do |i|
        @rn += i
        User.create!(
          name: Faker::Name.name,
          username: Faker::Internet.unique.username,
          alternative_email: Faker::Internet.email,
          registration_number: @rn,
          cpf: Faker::CPF.numeric,
          admin: @bol.sample,
          active: @bol.sample,
          password: '123456',
          support: false
        )
      end
    end
  end
end
