require 'rails_helper'

describe 'Admin::Departments::Members::create', type: :feature do
  let(:admin) { create(:user, :admin) }
  let!(:users) { create_list(:user, 3) }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:member) { create(:role, :member_department) }
  let(:resource_name) { I18n.t('views.names.member.singular') }

  before(:each) do
    create(:role, :responsible)
    login_as(admin, scope: :user)
    visit admin_department_members_path(department)
  end

  context 'with valid fields' do
    it 'add member manager' do
      find(:css, 'select[id="member_user"]', match: :first).select users[0].name
      find(:css, 'select[id="member_role"]', match: :first).select manager.name

      find('[name=button]').click

      expect(page).to have_current_path admin_department_members_path(department)
      expect(page).to have_flash(:success, text: flash_msg('add.m'))

      within('table tbody') do
        expect(page).to have_content(users[0].name)
        expect(page).to have_content(manager.name)
      end
    end

    it 'add member member' do
      find(:css, 'select[id="member_user"]', match: :first).select users.last.name
      find(:css, 'select[id="member_role"]', match: :first).select member.name

      find('[name=button]').click

      expect(page).to have_current_path admin_department_members_path(department)
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

      expect(page).to have_current_path admin_department_members_path(department)

      member = 'activerecord.attributes.department_user.user'
      role = 'activerecord.attributes.department_user.role'
      expect(page).to have_flash(:danger, text: required_error_msg_for(member))
      expect(page).to have_flash(:danger, text: required_error_msg_for(role))
    end

    it 'filled blank role show errors' do
      find(:css, 'select[id="member_user"]', match: :first).select users.last.name

      find('[name=button]').click
      expect(page).to have_current_path admin_department_members_path(department)

      role = 'activerecord.attributes.department_user.role'
      expect(page).to have_flash(:danger, text: required_error_msg_for(role))
    end

    it 'filled blank user show errors' do
      find(:css, 'select[id="member_role"]', match: :first).select member.name

      find('[name=button]').click

      expect(page).to have_current_path admin_department_members_path(department)

      member = 'activerecord.attributes.department_user.user'
      expect(page).to have_flash(:danger, text: required_error_msg_for(member))
    end
  end

  context 'when the manager' do
    it 'is already added' do
      find(:css, 'select[id="member_user"]', match: :first).select users.first.name
      find(:css, 'select[id="member_role"]', match: :first).select manager.name
      expect(page).to have_selector('select option', text: manager.name)
      find('[name=button]').click
      expect(page).not_to have_selector(id: 'select option', text: manager.name)
    end
  end

  context 'when the user' do
    it 'is already added' do
      find(:css, 'select[id="member_user"]', match: :first).select users.first.name
      find(:css, 'select[id="member_role"]', match: :first).select manager.name
      expect(page).to have_selector('select option', text: users.first.name)
      find('[name=button]').click
      expect(page).not_to have_selector(id: 'select option', text: users.first.name)
    end
  end
end
