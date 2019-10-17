require 'rails_helper'

describe 'Staff::Departments::Members::destroy', type: :feature do
  let(:staff) { create(:user) }
  let!(:div_user) { create(:division_users, user: staff, role: responsible) }
  let!(:div_user2) { create(:division_users, division: div_user.division, role: member_division) }
  let(:responsible) { create(:role, :responsible) }
  let(:member_division) { create(:role, :member_division) }
  let(:resource_name) { I18n.t('views.names.member.singular') }

  before(:each) do
    create(:role, :manager)
    login_as(staff, scope: :user)
    visit staff_department_division_members_path(div_user.division.department_id,
                                                 div_user.division_id)
  end

  describe '#destroy' do
    context 'when department is destroyed' do
      it 'show success message' do
        click_on_link(staff_department_division_remove_member_path(div_user2.division.department_id,
                                                                   div_user2.division_id,
                                                                   div_user2.user_id),
                      method: :delete)

        expect(page).to have_current_path(staff_department_division_members_path(
                                            div_user.division.department_id,
                                            div_user.division_id
                                          ))

        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))

        within('table tbody') do
          expect(page).not_to have_content(div_user2.user.name)
        end
      end
    end
  end
end
