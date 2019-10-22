require 'rails_helper'

describe 'Staff::Divisions::destroy', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { Division.model_name.human }
  let(:department_user) { create(:department_users, user: staff) }
  let!(:division) { create(:division, department_id: department_user.department_id) }
  let(:responsible) { create(:role, :responsible) }

  before(:each) do
    login_as(staff, scope: :user)
  end

  describe '#destroy' do
    context 'when division is destroyed' do
      it 'show success message' do
        visit staff_department_divisions_path(division.department_id)
        click_on_link(staff_department_division_path(division.department_id,
                                                     division.id),
                      method: :delete)

        expect(page).to have_current_path staff_divisions_path
        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))
        within('table tbody') do
          expect(page).not_to have_content(division.name)
        end
      end

      it 'show not permission' do
        div_users = create(:division_users, user: staff, role: responsible)
        visit staff_divisions_path
        click_on_link(staff_department_division_path(div_users.division.department_id,
                                                     div_users.division_id),
                      method: :delete)
        expect(page).to have_current_path staff_divisions_path
        expect(page).to have_flash(:danger, text: 'não possui permissão para remover Divisão')
        within('table tbody') do
          expect(page).to have_content(div_users.division.name)
        end
      end
    end
  end
end
