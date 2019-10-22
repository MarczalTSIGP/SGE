require 'rails_helper'

describe 'Admin::Divisions::create', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { Division.model_name.human }
  let(:department) { create(:department) }

  before(:each) do
    login_as(admin, scope: :user)
    visit new_admin_department_division_path(department)
  end

  context 'with valid fields' do
    it 'create an department' do
      attributes = attributes_for(:department)

      fill_in 'division_name', with: attributes[:name]
      fill_in 'division_description', with: attributes[:description]
      submit_form

      expect(page).to have_current_path admin_department_divisions_path(department)
      expect(page).to have_flash(:success, text: flash_msg('create.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:name])
      end
    end
  end

  context 'with fields' do
    it 'filled blank show errors' do
      submit_form

      expect(page).to have_flash(:danger, text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.division_name')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.division_description')
    end
  end
end
