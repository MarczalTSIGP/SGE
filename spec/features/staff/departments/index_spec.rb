require 'rails_helper'

describe 'Staff::Departments::index', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { Department.model_name.human }
  let(:manager) { create(:role, :manager) }
  let!(:depts_user) do
    create_list(:department_users, 3,
                user_id: staff.id,
                role_id: manager.id)
  end

  before(:each) do
    login_as(staff, scope: :user)
    visit staff_departments_path
  end

  context 'with data' do
    it 'showed' do
      within('table tbody') do
        depts_user.each do |dept_user|
          department = dept_user.department
          expect(page).to have_content(department.initials)
          expect(page).to have_content(department.local)
          expect(page).to have_content(department.email)
          expect(page).to have_content(department.phone)

          expect(page).to have_link(href: staff_department_path(department))
          expect(page).to have_link(href: edit_staff_department_path(department))
          expect(page).to have_link(href: staff_department_members_path(department))
        end
      end
    end
  end
end
