require 'rails_helper'

RSpec.describe 'Staff::Devise::UsersSessions', type: :feature do
  let(:user) { create(:user) }

  describe 'logout' do
    before(:each) do
      login_as(user, scope: :user)
    end

    it 'displays success logout message' do
      visit staff_root_url

      click_link(href: destroy_user_session_path)

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_flash(:info, text: devise_signed_out_msg)
    end
  end
end
