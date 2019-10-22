require 'rails_helper'

describe 'Staff::Departments::show', type: :feature do
  let(:staff) { create(:user) }
  let(:department) { create(:department) }
  let(:manager) { create(:role, :manager) }
  let(:dept_users) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
  end

  before(:each) do
    login_as(staff, scope: :user)
    visit staff_department_path(dept_users.department)
  end

  context 'with data' do
    it 'showed ' do
      expect(page).to have_content(department.name)
      expect(page).to have_content(department.initials)
      expect(page).to have_content(department.local)
      expect(page).to have_content(department.email)
      expect(page).to have_content(department.phone)
      expect(page).to have_content(department.description)
    end
  end

  context 'with links' do
    it { expect(page).to have_link(I18n.t('views.links.back'), href: staff_departments_path) }
  end
end
