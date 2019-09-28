require 'rails_helper'

describe 'Admins::Users::search', type: :feature do
  let(:admin) { create(:user, :admin) }
  let!(:users) { create_list(:user, 3) }
  let(:resource_name) { User.model_name.human.downcase }
  let(:resource_name_plural) { User.model_name.human.pluralize.downcase }

  before(:each) do
    login_as(admin, scope: :user)
    visit admin_users_path
  end

  context 'with data' do
    it 'search an unique field' do
      user = users.first
      visit admin_users_search_path(user.username)

      expect(page.html).to include(pagination_one_entry)

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(I18n.t("views.boolean.#{user.active}"))
      expect(page).to have_content(I18n.t("views.boolean.#{user.admin}"))

      expect(page).to have_link(href: admin_user_path(user))
      expect(page).to have_link(href: edit_admin_user_path(user))

      path = user.active? ? admin_user_disable_path(user) : admin_user_active_path(user)
      expect(page).to have_link(href: path)
    end

    it 'search an user using common name' do
      visit admin_users_search_path('nome')

      expect(page.html).to include(pagination_total_entries(count: 4))

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

    it 'search with no existent term' do
      visit admin_users_search_path('no-existent-term')

      expect(page.html).to include(pagination_zero_entries)
    end
  end

  context 'with no data' do
    it 'show all users' do
      visit admin_users_search_path('')

      expect(page.html).to include(pagination_total_entries(count: 4))

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
