require 'rails_helper'

describe 'Admin::Departments::index', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { Department.model_name.human }

  before(:each) do
    login_as(admin, scope: :user)
  end

  context 'with data' do
    it 'showed' do
      departments = create_list(:department, 3)
      visit admin_departments_path

      within('table tbody') do
        departments.each do |department|
          expect(page).to have_content(department.initials)
          expect(page).to have_content(department.local)
          expect(page).to have_content(department.email)
          expect(page).to have_content(department.phone)

          expect(page).to have_link(href: admin_department_path(department), count: 2)
          expect(page).to have_link(href: edit_admin_department_path(department))
          expect(page).to have_link(href: admin_department_members_path(department))
        end
      end
    end
  end

  context 'with links' do
    before(:each) { visit admin_departments_path }

    it {
      expect(page).to have_link(I18n.t('views.links.department.new'),
                                href: new_admin_department_path)
    }
  end
end
