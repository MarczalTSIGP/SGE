require 'rails_helper'

describe 'Admins::Users::index', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { User.model_name.human }

  before(:each) do
    login_as(admin, scope: :user)
  end

  context 'with data' do
    it 'showed' do
      users = create_list(:user, 3)
      visit admin_users_path

      within('table tbody') do
        users.each do |user|
          expect(page).to have_content(user.name)
          expect(page).to have_content(user.email)
          expect(page).to have_content(I18n.t("views.boolean.#{user.active}"))
          expect(page).to have_content(I18n.t("views.boolean.#{user.admin}"))

          expect(page).to have_link(href: admin_user_path(user))
          expect(page).to have_link(href: edit_admin_user_path(user))

          path = user.active? ? admin_user_disable_path(user) : admin_user_active_path(user)
          expect(page).to have_link(href: path)
        end
      end
    end
  end

  context 'with links' do
    before(:each) { visit admin_users_path }

    it { expect(page).to have_link(I18n.t('views.links.users.new'), href: new_admin_user_path) }
  end

  context 'when disable enable users' do
    let!(:user) { create(:user) }
    let!(:inactive_user) { create(:user, :inactive) }

    before(:each) do
      visit admin_users_path
    end

    it 'disable user' do
      click_link(href: admin_user_disable_path(user))

      expect(page).to have_flash(:success, text: flash_msg('disable.m'))
      expect(page).to have_link(href: admin_user_active_path(user))
    end

    it 'enable user' do
      click_link(href: admin_user_active_path(inactive_user))

      expect(page).to have_flash(:success, text: flash_msg('active.m'))
      expect(page).to have_link(href: admin_user_disable_path(inactive_user))
    end
  end
end
