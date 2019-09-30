require 'rails_helper'

describe 'Admin::Departments::Members::destroy', type: :feature do
  let(:admin) { create(:user, :admin) }
  let!(:div_users) { create(:division_users) }
  let(:responsible) { create(:role, :responsible) }
  let(:resource_name) { I18n.t('views.names.member.singular') }

  before(:each) do
    create(:role, :manager)
    login_as(admin, scope: :user)
    visit admin_department_division_members_path(div_users.division.department_id,
                                                 div_users.division_id)
  end

  describe '#destroy' do
    context 'when department is destroyed' do
      it 'show success message' do
        click_on_link(admin_department_division_remove_member_path(div_users.division.department_id,
                                                                   div_users.division_id,
                                                                   div_users.user_id),
                      method: :delete)

        expect(page).to have_current_path(
          admin_department_division_members_path(
            div_users.division.department_id,
            div_users.division_id
          )
        )

        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))

        within('table tbody') do
          expect(page).not_to have_content(div_users.user.name)
        end
      end
    end
  end
end
