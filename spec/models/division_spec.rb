require 'rails_helper'

RSpec.describe Division, type: :model do
  describe 'validations' do
    context 'when matchers' do
      subject { create(:division) }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:description) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:users).through(:division_users) }
    it { is_expected.to have_many(:roles).through(:division_users) }
    it { is_expected.to belong_to(:department) }
    it { is_expected.to have_many(:division_users) }
  end

  describe '.search' do
    let(:division) { create(:division) }

    context 'without params' do
      it 'returns department by name' do
        divisions = Division.search(nil)
        expect(divisions).to include(division)
      end
    end

    context 'with attributes' do
      it 'returns divisions by name' do
        divisions = Division.search(division.name)
        expect(division.name).to eq(divisions.first.name)
      end
    end

    context 'with accents' do
      it 'in attribute' do
        division = create(:division, name: 'Departamento de Materiais e Patrimônio')
        divisions = Division.search('Patrimonio')
        expect(division.name).to eq(divisions.first.name)
      end

      it 'in search term' do
        division = create(:division, name: 'Departamento de Materiais e Patrimonio')
        divisions = Division.search('Patrimônio')
        expect(division.name).to eq(divisions.first.name)
      end
    end

    context 'with ignoring case sensitive' do
      it 'in attribute' do
        division = create(:division, name: 'Departamento de Materiais e Patrimonio')
        divisions = Division.search('de')
        expect(division.name).to eq(divisions.first.name)
      end

      it 'in search term' do
        division = create(:division, name: 'departamento de materiais e patrimonio')
        divisions = Division.search('DEPAR')
        expect(division.name).to eq(divisions.first.name)
      end
    end
  end

  describe 'members' do
    let(:division) { create(:division) }

    it 'not add a member to division twice' do
      member = create(:user)
      role = create(:role, :member_division)
      du = DivisionUser.new(user_id: member.id, role_id: role.id)

      division.division_users << du
      expect(division.users.count).to eq(1)

      division.division_users << du
      expect(division.users.count).to eq(1)
    end
  end

  describe ',responsible' do
    let(:division_users) { create(:division_users) }

    it 'return if the user is a responsible' do
      result = Division.responsible(division_users.user_id)
      division = division_users.division
      expect(result.first).to eq(division)
    end
  end
end
