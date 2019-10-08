require 'rails_helper'

describe 'Admin::Departments::update', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { Division.model_name.human }
  let(:department) { create(:department) }
  let(:division) { create(:division, department: department) }

  before(:each) do
    login_as(admin, scope: :user)
    visit edit_admin_department_division_path(department, division)
  end

  context 'when render edit' do
    it 'fields should be filled' do
      expect(page).to have_field('division_name', with: division.name)
      expect(page).to have_field('division_description', with: division.description)
    end
  end

  context 'with valid fields' do
    it 'update contact' do
      attributes = attributes_for(:division)

      fill_in 'division_name', with: attributes[:name]
      fill_in 'division_description', with: attributes[:description]
      submit_form

      expect(page).to have_current_path admin_department_divisions_path(department)
      expect(page).to have_flash(:success, text: flash_msg('update.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:name])
      end
    end
  end

  context 'with invalids fields' do
    it 'show errors when fields are blank' do
      fill_in 'division_name', with: ''
      fill_in 'division_description', with: ''

      submit_form

      expect(page).to have_flash(:danger, text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.division_name')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.division_description')
    end
  end
end
