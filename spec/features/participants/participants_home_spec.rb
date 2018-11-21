require 'rails_helper'

RSpec.describe 'Participants::Home', type: :feature do
  describe 'GET /admin' do
    it 'access home admin namespace' do
      visit participants_root_path

      expect(page).to have_text('Participant')
    end
  end
end
