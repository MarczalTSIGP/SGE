require 'rails_helper'

RSpec.describe 'Participants::Home', type: :feature do
  let(:client) { create(:client) }

  describe 'GET /partcipants' do
    it ' access home partcipants namespace' do
      sign_in client
      visit participants_root_path
      expect(page).to have_selector(:css, 'a[href="/participants"]')
      expect(page).to have_text('Participant')
    end
  end
end
