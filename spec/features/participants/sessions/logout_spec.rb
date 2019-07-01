require 'rails_helper'

RSpec.describe 'Participants::Devise::Sessions', type: :feature do
  let(:user) { create(:client) }

  describe 'logout' do
    before(:each) do
      login_as(user, scope: :client)
    end

    it 'displays success logout message' do
      visit participants_root_url

      click_link(href: destroy_client_session_path)

      expect(page).to have_current_path(new_client_session_path)
      expect(page).to have_flash(:info, text: devise_signed_out_msg)
    end
  end
end
