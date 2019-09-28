module Populate
  class Roles
    def initialize
      @roles = [
        ['Chefe de Departamento', :manager, true],
        ['Membro do Departamento', :member_department, true],
        ['Responsavel da Divisão', :responsible, false],
        ['Membro da Divisão', :member_division, false]
      ]
    end

    def populate
      create_roles
    end

    private

    def create_roles
      @roles.each do |name, identifier, department|
        Role.find_or_create_by!(name: name, identifier: identifier, department: department)
      end
    end
  end
end
