require 'rails_helper'

RSpec.feature "Admin::Home", type: :feature do
  describe 'GET /admin' do
    it "should access home admin namespace" do
      visit admin_root_path
      expect(page).to have_selector(:css, 'a[href="/admin"]')
      expect(page).to have_text('Admin')
    end
  end
end
