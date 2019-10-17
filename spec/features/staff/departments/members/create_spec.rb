require 'rails_helper'

describe 'Staff::Departments::Members::create', type: :feature do
  let(:staff) { create(:user) }
  let!(:users) { create_list(:user, 3) }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:member) { create(:role, :member_department) }
  let(:dept_users) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
  end
  let(:resource_name) { I18n.t('views.names.member.singular') }

  before(:each) do
    create(:role, :responsible)
    login_as(staff, scope: :user)
    visit staff_department_members_path(dept_users.department)
  end

  context 'with valid fields' do
    it 'add member member' do
      find(:css, 'select[id="member_user"]', match: :first).select users.last.name
      find(:css, 'select[id="member_role"]', match: :first).select member.name

      find('[name=button]').click

      expect(page).to have_current_path staff_department_members_path(department)
      expect(page).to have_flash(:success, text: flash_msg('add.m'))

      within('table tbody') do
        expect(page).to have_content(users.last.name)
        expect(page).to have_content(member.name)
      end
    end
  end

  context 'with fields' do
    it 'filled blank show errors' do
      find('[name=button]').click

      expect(page).to have_current_path staff_department_members_path(department)

      member = 'activerecord.attributes.department_user.user'
      role = 'activerecord.attributes.department_user.role'
      expect(page).to have_flash(:danger, text: required_error_msg_for(member))
      expect(page).to have_flash(:danger, text: required_error_msg_for(role))
    end

    it 'filled blank role show errors' do
      find(:css, 'select[id="member_user"]', match: :first).select users.last.name

      find('[name=button]').click
      expect(page).to have_current_path staff_department_members_path(department)

      role = 'activerecord.attributes.department_user.role'
      expect(page).to have_flash(:danger, text: required_error_msg_for(role))
    end

    it 'filled blank user show errors' do
      find(:css, 'select[id="member_role"]', match: :first).select member.name

      find('[name=button]').click

      expect(page).to have_current_path staff_department_members_path(department)

      member = 'activerecord.attributes.department_user.user'
      expect(page).to have_flash(:danger, text: required_error_msg_for(member))
    end
  end
end
