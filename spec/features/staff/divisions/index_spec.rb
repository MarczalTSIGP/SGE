require 'rails_helper'

describe 'Staff::Divisions::index', type: :feature do
  let(:staff) { create(:user) }
  let(:department_user) { create(:department_users, user: staff) }
  let!(:divs) { create_list(:division, 3, department_id: department_user.department_id) }
  let(:resource_name) { Division.model_name.human }

  before(:each) do
    login_as(staff, scope: :user)
  end

  context 'with data' do
    it 'showed' do
      visit staff_department_divisions_path(divs[0].department_id)
      within('table tbody') do
        divs.each do |div|
          expect(page).to have_content(div.name)

          expect(page).to have_link(href: staff_department_division_path(div.department_id, div.id),
                                    count: 2)
          expect(page).to have_link(href: edit_staff_department_division_path(div.department_id,
                                                                              div))
          expect(page).to have_link(href: staff_department_division_members_path(div.department_id,
                                                                                 div))
        end
      end
    end
    it 'not permission' do
      div = create(:division)
      visit staff_department_divisions_path(div.department_id)
      expect(page).to have_current_path staff_root_path
      expect(page).not_to have_content(div.name)
    end
  end

  context 'with links' do
    before(:each) { visit staff_department_divisions_path(divs[0].department_id) }

    it {
      expect(page).to have_link(I18n.t('views.links.division.new'),
                                href: new_staff_department_division_path(divs[0].department_id))
    }
  end
end
