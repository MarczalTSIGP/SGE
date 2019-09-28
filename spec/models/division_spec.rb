require 'rails_helper'

RSpec.describe Division, type: :model do
  describe 'validations' do
    context 'when matchers' do
      subject { create(:division) }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:kind) }
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

  describe '.kinds' do
    subject(:division) { Division.new }

    it 'enum' do
      expect(division).to define_enum_for(:kind)
        .with_values(certified: 'certified', event: 'event')
        .backed_by_column_of_type(:enum)
        .with_prefix(:kind)
    end

    it 'human enum' do
      hash = { I18n.t('enums.kinds.event') => 'event',
               I18n.t('enums.kinds.certified') => 'certified' }

      expect(Division.human_kinds).to include(hash)
    end

    it 'validates presence of kind' do
      c = Division.new
      c.valid?

      expect(c.errors.messages[:kind]).to include(I18n.t('errors.messages.blank'))
    end
  end
end
