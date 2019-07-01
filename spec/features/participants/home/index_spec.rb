require 'rails_helper'

RSpec.describe 'Participants::Home::index', type: :feature do
  let(:user) { create(:client) }

  describe 'GET /partcipants' do
    it ' access home partcipants namespace' do
      login_as(user, scope: :client)
      visit participants_root_path

      expect(page).to have_current_path(participants_root_path)
      expect(page).to have_text('Dashboard')
    end
  end
end
