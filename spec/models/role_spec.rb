require 'rails_helper'

RSpec.describe Role, type: :model do
  let!(:department_users) { create(:department_users) }
  let!(:division_users) { create(:division_users) }

  describe 'associations' do
    it { is_expected.to have_many(:department_users) }
  end

  describe 'where' do
    before(:each) do
      create(:role, :member_department)
      create(:role, :member_division)
    end

    context 'with department ' do
      it 'manager add' do
        r = Role.where_roles(department_users.department_id, false)
        expect(r.count).to eq(1)
      end

      it 'all' do
        department_users.destroy
        r = Role.where_roles(department_users.department_id, false)
        expect(r.count).to eq(2)
      end
    end

    context 'with division' do
      it 'responsible add' do
        r = Role.where_roles(division_users.division_id, true)
        expect(r.count).to eq(1)
      end

      it 'all' do
        division_users.destroy
        r = Role.where_roles(division_users.division_id, true)
        expect(r.count).to eq(2)
      end
    end
  end
end
