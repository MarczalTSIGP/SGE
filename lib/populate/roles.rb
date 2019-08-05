module Populate
  class Roles
    def initialize
      @roles = [
        ['Chefe de Departamento', :manager],
        ['Membro do Departamento', :member]
      ]
    end

    def populate
      create_roles
    end

    private

    def create_roles
      @roles.each do |name, identifier|
        Role.find_or_create_by!(name: name, identifier: identifier)
      end
    end
  end
end
