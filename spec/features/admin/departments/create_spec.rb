require 'rails_helper'

describe 'Admin::Departments::create', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { Department.model_name.human }

  before(:each) do
    login_as(admin, scope: :user)
    visit new_admin_department_path
  end

  context 'with valid fields' do
    it 'create an department' do
      attributes = attributes_for(:department)

      fill_in 'department_name', with: attributes[:name]
      fill_in 'department_initials', with: attributes[:initials]
      fill_in 'department_phone', with: attributes[:phone]
      fill_in 'department_email', with: attributes[:email]
      fill_in 'department_local', with: attributes[:local]
      submit_form

      expect(page).to have_current_path admin_departments_path
      expect(page).to have_flash(:success, text: flash_msg('create.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:initials])
        expect(page).to have_content(attributes[:local])
        expect(page).to have_content(attributes[:email])
        expect(page).to have_content(attributes[:phone])
      end
    end
  end

  context 'with fields' do
    it 'filled blank show errors' do
      submit_form

      expect(page).to have_flash(:danger, text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.department_name')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.department_initials')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.department_phone')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.department_email')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.department_local')
    end

    it 'smaller phone size' do
      fill_in 'department_phone', with: ''
      submit_form

      expect(page).to have_message(sf_length_minimum(10), in: 'div.department_phone')
    end
    it 'larger phone size' do
      fill_in 'department_phone', with: '(00) 00000-0000'
      submit_form

      expect(page).to have_message(sf_length_maximum(14), in: 'div.department_phone')
    end
    it 'initials length' do
      fill_in 'department_initials', with: ''
      submit_form

      expect(page).to have_message(sf_length_minimum(3), in: 'div.department_initials')
    end
  end
end
