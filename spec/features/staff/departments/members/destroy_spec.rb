require 'rails_helper'

describe 'Staff::Departments::Members::destroy', type: :feature do
  let(:user) { create(:user) }
  let!(:div) { create(:division) }
  let!(:dept_users) do
    create(:department_users, user_id: user.id, department_id: div.department_id)
  end
  let(:resource_name) { I18n.t('views.names.member.singular') }

  before(:each) do
    create(:role, :responsible)
    login_as(user, scope: :user)
    visit staff_department_members_path(dept_users.department_id)
  end

  describe '#destroy' do
    context 'when department is destroyed' do
      it 'show success message' do
        click_on_link(staff_department_remove_member_path(dept_users.department_id,
                                                          dept_users.user_id),
                      method: :delete)

        expect(page).to have_current_path staff_departments_path
        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))
        within('table tbody') do
          expect(page).not_to have_content(dept_users.user.name)
        end
      end

      it 'show bound message' do
        create(:division_users, user_id: user.id, division_id: div.id)
        click_on_link(staff_department_remove_member_path(dept_users.department_id,
                                                          dept_users.user_id),
                      method: :delete)

        expect(page).to have_current_path staff_department_members_path(dept_users.department_id)
        expect(page).to have_flash(:danger, text: flash_msg('destroy.bound'))

        within('table tbody') do
          expect(page).to have_content(dept_users.user.name)
        end
      end
    end
  end
end
