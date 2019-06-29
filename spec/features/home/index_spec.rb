require 'rails_helper'

RSpec.describe 'Home', type: :feature do
  describe 'GET /' do
    it 'show text and links' do
      visit root_path

      within('.card-header') do
        expect(page).to have_text(I18n.t('views.app.title'))
      end

      within('.card-body .row-cards div:nth-child(1) .card') do
        expect(page).to have_link(I18n.t('views.home.admin.access'), href: new_user_session_path)
        expect(page).to have_text(I18n.t('views.home.admin.plural'))
      end

      within('.card-body .row-cards div:nth-child(2) .card') do
        expect(page).to have_link(I18n.t('views.home.server.access'),
                                  href: new_user_session_path)
        expect(page).to have_text(I18n.t('views.home.server.plural'))
      end

      within('.card-body .row-cards div:nth-child(3) .card') do
        expect(page).to have_link(I18n.t('views.home.client.access'),
                                  href: new_client_session_path)
        expect(page).to have_text(I18n.t('views.home.client.plural'))
      end
    end
  end
end
