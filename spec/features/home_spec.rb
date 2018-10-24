require 'rails_helper'

RSpec.feature 'Home', type: :feature do
  describe 'GET /' do
    it 'should access home public namespace' do
      visit root_path
      expect(page).to have_text('public')
    end
  end
end
