require 'rails_helper'

describe 'Admins::Users::show', type: :feature do
  let(:admin) { create(:user, :admin) }

  before(:each) do
    login_as(admin, scope: :user)
  end

  context 'with data' do
    it 'showed admin and active' do
      user = create(:user, :admin)
      visit admin_user_path(user)

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(I18n.t("views.boolean.#{user.active}"))
      expect(page).to have_content(I18n.t("views.boolean.#{user.admin}"))
    end

    it 'showed not admin and not active' do
      user = create(:user, :inactive)
      visit admin_user_path(user)

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(I18n.t("views.boolean.#{user.active}"))
      expect(page).to have_content(I18n.t("views.boolean.#{user.admin}"))
    end
  end

  context 'with links' do
    before(:each) do
      user = create(:user)
      visit admin_user_path(user)
    end

    it { expect(page).to have_link(I18n.t('views.links.back'), href: admin_users_path) }
  end
end
