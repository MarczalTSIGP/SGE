require 'rails_helper'

describe 'Admin::Departments::Members::destroy', type: :feature do
  let(:admin) { create(:user, :admin) }
  let!(:dept_users) { create(:department_users) }
  let(:resource_name) { I18n.t('views.names.member.singular') }

  before(:each) do
    create(:role, :responsible)
    login_as(admin, scope: :user)
    visit admin_department_members_path(dept_users.department_id)
  end

  describe '#destroy' do
    context 'when department is destroyed' do
      it 'show success message' do
        click_on_link(admin_department_remove_member_path(dept_users.department_id,
                                                          dept_users.user_id),
                      method: :delete)

        expect(page).to have_current_path admin_department_members_path(dept_users.department_id)
        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))

        within('table tbody') do
          expect(page).not_to have_content(dept_users.user.name)
        end
      end
    end
  end
end
