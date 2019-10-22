require 'rails_helper'

describe 'Staff::Departments::update', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { Department.model_name.human }
  let(:department) { create(:department) }
  let(:manager) { create(:role, :manager) }
  let(:dept_users) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
  end

  before(:each) do
    login_as(staff, scope: :user)
    visit edit_staff_department_path(dept_users.department)
  end

  context 'when render edit' do
    it 'fields should be filled' do
      expect(page).to have_field('department_name', with: department.name)
      expect(page).to have_field('department_initials', with: department.initials)
      expect(page).to have_field('department_phone', with: department.phone)
      expect(page).to have_field('department_email', with: department.email.remove('@utfpr.edu.br'))
      expect(page).to have_field('department_local', with: department.local)
      expect(page).to have_field('department_description', with: department.description)
    end
  end

  context 'with valid fields' do
    it 'update contact' do
      attributes = attributes_for(:department)

      fill_in 'department_name', with: attributes[:name]
      fill_in 'department_initials', with: attributes[:initials]
      fill_in 'department_phone', with: attributes[:phone]
      fill_in 'department_email', with: attributes[:email].remove('@utfpr.edu.br')
      fill_in 'department_local', with: attributes[:local]
      fill_in 'department_description', with: attributes[:description]

      submit_form

      expect(page).to have_current_path staff_departments_path
      expect(page).to have_flash(:success, text: flash_msg('update.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:initials])
        expect(page).to have_content(attributes[:local])
        expect(page).to have_content(attributes[:email])
        expect(page).to have_content(attributes[:phone])
      end
    end
  end

  context 'with invalids fields' do
    it 'show errors when fields are blank' do
      fill_in 'department_name', with: ''
      fill_in 'department_initials', with: ''
      fill_in 'department_phone', with: ''
      fill_in 'department_email', with: ''
      fill_in 'department_local', with: ''

      submit_form

      expect(page).to have_flash(:danger, text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.department_name')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.department_initials')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.department_phone')
      expect(page).to have_message(sf_invalid_error_msg, in: 'div.department_email')
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
