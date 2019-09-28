require 'rails_helper'

describe 'Admin::Divisions::index', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:department) { create(:department) }
  let(:resource_name) { Division.model_name.human }

  before(:each) do
    login_as(admin, scope: :user)
  end

  context 'with data' do
    it 'showed' do
      divisions = create_list(:division, 3, department: department)
      visit admin_department_divisions_path(department)
      within('table tbody') do
        divisions.each do |division|
          expect(page).to have_content(division.name)

          expect(page).to have_link(href: admin_department_division_path(department, division.id),
                                    count: 2)
          expect(page).to have_link(href: edit_admin_department_division_path(department, division))
          expect(page).to have_link(href: admin_department_division_members_path(department,
                                                                                 division))
        end
      end
    end
  end

  context 'with links' do
    before(:each) { visit admin_department_divisions_path(department) }

    it {
      expect(page).to have_link(I18n.t('views.links.division.new'),
                                href: new_admin_department_division_path(department))
    }
  end
end
