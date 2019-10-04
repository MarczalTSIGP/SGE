require 'rails_helper'

describe 'Admin::Divisions::Members::create', type: :feature do
  let(:admin) { create(:user, :admin) }
  let!(:department) { create(:department) }
  let!(:dept_users) { create_list(:department_users, 3, department: department) }
  let!(:division) { create(:division, department: department) }
  let!(:responsible) { create(:role, :responsible) }
  let!(:member) { create(:role, :member_division) }

  let(:resource_name) { I18n.t('views.names.member.singular') }

  before(:each) do
    create(:role, :manager)
    login_as(admin, scope: :user)
    visit admin_department_division_members_path(department, division)
  end

  context 'with valid fields' do
    it 'add member manager' do
      find(:css, 'select[id="member_user"]', match: :first).select dept_users[0].user.name
      find(:css, 'select[id="member_role"]', match: :first).select responsible.name

      find('[name=button]').click

      expect(page).to have_current_path admin_department_division_members_path(department, division)
      expect(page).to have_flash(:success, text: flash_msg('add.m'))

      within('table tbody') do
        expect(page).to have_content(dept_users[0].user.name)
        expect(page).to have_content(responsible.name)
      end
    end

    it 'add member member' do
      find(:css, 'select[id="member_user"]', match: :first).select dept_users[1].user.name
      find(:css, 'select[id="member_role"]', match: :first).select member.name

      find('[name=button]').click

      expect(page).to have_current_path admin_department_division_members_path(department, division)
      expect(page).to have_flash(:success, text: flash_msg('add.m'))

      within('table tbody') do
        expect(page).to have_content(dept_users[1].user.name)
        expect(page).to have_content(member.name)
      end
    end
  end

  context 'with fields' do
    it 'filled blank show errors' do
      find('[name=button]').click

      expect(page).to have_current_path admin_department_division_members_path(department, division)

      member = 'activerecord.attributes.division_user.user'
      role = 'activerecord.attributes.division_user.role'
      expect(page).to have_flash(:danger, text: required_error_msg_for(member))
      expect(page).to have_flash(:danger, text: required_error_msg_for(role))
    end

    it 'filled blank role show errors' do
      find(:css, 'select[id="member_user"]', match: :first).select dept_users[1].user.name

      find('[name=button]').click

      expect(page).to have_current_path admin_department_division_members_path(department, division)

      role = 'activerecord.attributes.division_user.role'
      expect(page).to have_flash(:danger, text: required_error_msg_for(role))
    end

    it 'filled blank user show errors' do
      find(:css, 'select[id="member_role"]', match: :first).select member.name

      find('[name=button]').click

      expect(page).to have_current_path admin_department_division_members_path(department, division)

      member = 'activerecord.attributes.division_user.user'
      expect(page).to have_flash(:danger, text: required_error_msg_for(member))
    end
  end

  context 'when the responsible' do
    it 'is already added' do
      find(:css, 'select[id="member_user"]', match: :first).select dept_users[0].user.name
      find(:css, 'select[id="member_role"]', match: :first).select responsible.name
      expect(page).to have_selector('select option', text: responsible.name)
      find('[name=button]').click
      expect(page).not_to have_selector(id: 'select option', text: responsible.name)
    end
  end

  context 'when the user' do
    it 'is already added' do
      find(:css, 'select[id="member_user"]', match: :first).select dept_users[0].user.name
      find(:css, 'select[id="member_role"]', match: :first).select responsible.name
      expect(page).to have_selector('select option', text: dept_users[0].user.name)
      find('[name=button]').click
      expect(page).not_to have_selector(id: 'select option', text: dept_users[0].user.name)
    end
  end
end
