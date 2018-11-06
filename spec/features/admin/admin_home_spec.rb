require 'rails_helper'

RSpec.feature 'Admin::Home', type: :feature do
  let(:user_acitve) { create(:user) }

  describe 'GET /admin' do
    it 'should access home admin namespace' do
      sign_in user_acitve
      visit admin_root_path
      expect(page).to have_selector(:css, 'a[href="/admin"]')
      expect(page).to have_text('Dashboard')
    end
  end
end
