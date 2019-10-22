require 'rails_helper'

describe 'Staff::Divisions::search', type: :feature do
  let(:staff) { create(:user) }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:divisions) { create_list(:division, 3, department: department) }
  let!(:division_diff) { create(:division, name: 'teste', department: department) }
  let(:resource_name) { Division.model_name.human.downcase }
  let(:resource_name_plural) { I18n.t('views.names.division.plural').downcase }

  before(:each) do
    create(:department_users, department: department, user: staff, role: manager)
    login_as(staff, scope: :user)
    visit staff_department_divisions_path(department)
  end

  context 'with data' do
    it 'search an unique field' do
      visit staff_department_divisions_search_path(department, division_diff.name)

      expect(page.html).to include(pagination_one_entry)

      expect(page).to have_content(division_diff.name)

      expect(page).to have_link(href: staff_department_division_path(department,
                                                                     division_diff.id), count: 2)
      expect(page).to have_link(href: edit_staff_department_division_path(department,
                                                                          division_diff))
      expect(page).to have_link(href: staff_department_division_members_path(department,
                                                                             division_diff))
    end

    it 'search an division using common name' do
      visit staff_department_divisions_search_path(department, 'nome')

      expect(page.html).to include(pagination_total_entries(count: 3))

      divisions.each do |division|
        expect(page).to have_content(division.name)

        expect(page).to have_link(href: staff_department_division_path(department,
                                                                       division.id), count: 2)
        expect(page).to have_link(href: edit_staff_department_division_path(department,
                                                                            division))
        expect(page).to have_link(href: staff_department_division_members_path(department,
                                                                               division))
      end
    end

    it 'search with no existent term' do
      visit staff_department_divisions_search_path(department, 'no-existent-term')

      expect(page.html).to include('0 divisões encontrado')
    end
  end

  context 'with no data' do
    it 'show all departments' do
      visit staff_department_divisions_search_path(department, '')

      expect(page.html).to include(pagination_total_entries(count: 4))

      divisions.each do |division|
        expect(page).to have_content(division.name)

        expect(page).to have_link(href: staff_department_division_path(department,
                                                                       division.id), count: 2)
        expect(page).to have_link(href: edit_staff_department_division_path(department, division))
        expect(page).to have_link(href: staff_department_division_members_path(department,
                                                                               division))
      end
    end
  end
end
