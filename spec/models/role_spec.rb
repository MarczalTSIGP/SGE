require 'rails_helper'

RSpec.describe Role, type: :model do
  let!(:department_users) { create(:department_users) }

  describe 'where ' do
    before(:each) do
      create(:role, :member)
    end

    context 'with role' do
      it 'manager add' do
        r = Role.where_roles(department_users.department_id)
        expect(r.count).to eq(1)
      end

      it 'all' do
        department_users.destroy
        r = Role.where_roles(department_users.department_id)
        expect(r.count).to eq(2)
      end
    end
  end
end
