require 'rails_helper'

describe 'Admins::Departments::search', type: :feature do
  let(:admin) { create(:user, :admin) }
  let!(:departments) { create_list(:department, 3) }
  let(:resource_name) { Department.model_name.human.downcase }
  let(:resource_name_plural) { Department.model_name.human.pluralize.downcase }

  before(:each) do
    login_as(admin, scope: :user)
    visit admin_departments_path
  end

  context 'with data' do
    it 'search an unique field' do
      department = departments.first
      visit admin_departments_search_path(department.initials)

      expect(page.html).to include(pagination_one_entry)

      expect(page).to have_content(department.initials)
      expect(page).to have_content(department.local)
      expect(page).to have_content(department.email)
      expect(page).to have_content(department.phone)

      expect(page).to have_link(href: admin_department_path(department), count: 2)
      expect(page).to have_link(href: edit_admin_department_path(department))
      expect(page).to have_link(href: admin_department_members_path(department))
    end

    it 'search an department using common name' do
      visit admin_departments_search_path('nome')

      expect(page.html).to include(pagination_total_entries(count: 3))

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

    it 'search with no existent term' do
      visit admin_departments_search_path('no-existent-term')

      expect(page.html).to include(pagination_zero_entries)
    end
  end

  context 'with no data' do
    it 'show all departments' do
      visit admin_departments_search_path('')

      expect(page.html).to include(pagination_total_entries(count: 3))

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
