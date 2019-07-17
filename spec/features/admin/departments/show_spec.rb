require 'rails_helper'

describe 'Admins::Departments::show', type: :feature do
  let(:admin) { create(:user, :admin) }

  before(:each) do
    login_as(admin, scope: :user)
  end

  context 'with data' do
    it 'showed ' do
      department = create(:department)
      visit admin_department_path(department)

      expect(page).to have_content(department.name)
      expect(page).to have_content(department.initials)
      expect(page).to have_content(department.local)
      expect(page).to have_content(department.email)
      expect(page).to have_content(department.phone)
      expect(page).to have_content(department.description)
    end
  end

  context 'with links' do
    before(:each) do
      department = create(:department)
      visit admin_department_path(department)
    end

    it { expect(page).to have_link(I18n.t('views.links.back'), href: admin_departments_path) }
  end
end
