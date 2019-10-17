require 'rails_helper'

RSpec.describe Department, type: :model do
  describe 'validations' do
    context 'when matchers' do
      subject { create(:department) }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:local) }
      it { is_expected.to validate_presence_of(:initials) }
      it { is_expected.to validate_presence_of(:phone) }

      it { is_expected.to validate_length_of(:email) }
      it { is_expected.to validate_length_of(:phone) }
      it { is_expected.to validate_length_of(:initials) }

      it { is_expected.to allow_value('email').for(:email) }
      it { is_expected.not_to allow_value('foo@hotmail.com').for(:email) }
      it { is_expected.to validate_uniqueness_of(:initials).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:email) }
    end

    describe 'converting to uppercase' do
      let(:department) { build(:department) }

      it 'initials lowercase' do
        department.initials = 'abc'
        expect(department.initials).to eql('ABC')
      end

      it 'initials capitalize' do
        department.initials = 'Abc'
        expect(department.initials).to eql('ABC')
      end
    end

    context 'when email' do
      let(:department) { build(:department) }

      it 'is invalid and used in email' do
        department.email = 'a a'
        department.valid?
        expect(department.errors[:email]).not_to be_empty
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:users).through(:department_users) }
    it { is_expected.to have_many(:roles).through(:department_users) }
    it { is_expected.to have_many(:departments).through(:department_users) }
    it { is_expected.to have_many(:department_users) }
  end

  describe '.search' do
    let(:department) { create(:department) }

    context 'without params' do
      it 'returns department by name' do
        departments = Department.search(nil)
        expect(departments).to include(department)
      end
    end

    context 'with attributes' do
      it 'returns departments by name' do
        departments = Department.search(department.name)
        expect(department.name).to eq(departments.first.name)
      end

      it 'returns departments by initials' do
        departments = Department.search(department.initials)
        expect(department.initials).to eq(departments.first.initials)
      end
    end

    context 'with accents' do
      it 'in attribute' do
        department = create(:department, name: 'Departamento de Materiais e Patrimônio')
        departments = Department.search('Patrimonio')
        expect(department.name).to eq(departments.first.name)
      end

      it 'in search term' do
        department = create(:department, name: 'Departamento de Materiais e Patrimonio')
        departments = Department.search('Patrimônio')
        expect(department.name).to eq(departments.first.name)
      end
    end

    context 'with ignoring case sensitive' do
      it 'in attribute' do
        department = create(:department, name: 'Departamento de Materiais e Patrimonio')
        departments = Department.search('de')
        expect(department.name).to eq(departments.first.name)
      end

      it 'in search term' do
        department = create(:department, name: 'departamento de materiais e patrimonio')
        departments = Department.search('DEPAR')
        expect(department.name).to eq(departments.first.name)
      end
    end
  end

  describe '#name_with_initials' do
    it 'returns department by name with initials' do
      department = create(:department, name: 'departamento de materiais e patrimonio')
      name_initials = department.name_with_initials
      expect("#{department.name} - #{department.initials}").to eq(name_initials)
    end
  end

  describe 'members' do
    let(:department) { create(:department) }

    it 'not add a member to a department twice' do
      member = create(:user)
      role = create(:role, :member_department)
      du = DepartmentUser.create(user_id: member.id, role_id: role.id)

      department.department_users << du
      expect(department.users.count).to eq(1)

      department.department_users << du
      expect(department.users.count).to eq(1)
    end
  end

  describe ',manager' do
    let(:department_users) { create(:department_users) }

    it 'return if the user is a manager' do
      result = Department.manager(department_users.user_id)
      department = department_users.department
      expect(result.first).to eq(department)
    end
  end
end
