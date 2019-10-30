require 'rails_helper'

describe 'Staff::Divisions::index_bound', type: :feature do
  let(:staff) { create(:user) }
  let(:department) { create(:department) }
  let!(:responsible) { create(:role, :responsible) }
  let!(:manager) { create(:role, :manager) }
  let!(:member_division) { create(:role, :member_division) }
  let(:resource_name) { Division.model_name.human }
  let(:dept_manager) { create(:department_users, role: manager, user: staff) }
  let!(:div_dept_manager) { create_list(:division, 3, department: dept_manager.department) }
  let!(:divs_responsible) { create_list(:division_users, 3, user: staff, role: responsible) }
  let!(:divs_member) { create_list(:division_users, 3, user: staff, role: member_division) }

  before(:each) do
    login_as(staff, scope: :user)
    visit staff_divisions_path
  end

  context 'with data' do
    it 'showed responsible' do
      within('table tbody') do
        divs_responsible.each do |div_user|
          div = div_user.division
          expect(page).to have_content(div.name)

          expect(page).to have_link(href: staff_department_division_path(div.department,
                                                                         div.id),
                                    count: 2)
          expect(page).to have_link(href: edit_staff_department_division_path(div.department,
                                                                              div))
          expect(page).to have_link(href: staff_department_division_members_path(div.department,
                                                                                 div))
        end
      end
    end

    it 'showed  department  manager in division' do
      within('table tbody') do
        div_dept_manager.each do |div|
          expect(page).to have_content(div.name)

          expect(page).to have_link(href: staff_department_division_path(div.department,
                                                                         div.id),
                                    count: 2)
          expect(page).to have_link(href: edit_staff_department_division_path(div.department,
                                                                              div))
          expect(page).to have_link(href: staff_department_division_members_path(div.department,
                                                                                 div))
        end
      end
    end

    it 'showed  division member' do
      within('table tbody') do
        divs_member.each do |div_user|
          div = div_user.division
          expect(page).to have_content(div.name)

          expect(page).to have_link(href: staff_department_division_path(div.department,
                                                                         div.id),
                                    count: 2)
          expect(page).to have_link(href: edit_staff_department_division_path(div.department,
                                                                              div))
          expect(page).to have_link(href: staff_department_division_members_path(div.department,
                                                                                 div))
        end
      end
    end
  end
end
