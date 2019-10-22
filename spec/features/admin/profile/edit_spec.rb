require 'rails_helper'

describe 'Admin::Registrations::edit', type: :feature do
  let(:resource_name) { User.model_name.human }
  let(:user) { create(:user, :admin) }

  before(:each) do
    login_as(user, scope: :user)
    visit admin_edit_user_registration_path
  end

  context 'when render edit' do
    it 'fields should be filled' do
      expect(page).to have_field('user_name', with: user.name)
      expect(page).to have_field('user_cpf', with: user.cpf)
      expect(page).to have_field('user_email', with: user.email)
      expect(page).to have_field('user_alternative_email', with: user.alternative_email)
      expect(page).to have_field('user_registration_number', with: user.registration_number)
    end
  end

  context 'with valid fields' do
    it 'update a client' do
      attributes = attributes_for(:user)

      fill_in 'user_name', with: attributes[:name]
      fill_in 'user_alternative_email', with: attributes[:alternative]
      fill_in 'user_registration_number', with: attributes[:registration_number]
      fill_in 'user_current_password', with: '123456'
      submit_form

      expect(page).to have_current_path(admin_edit_user_registration_path)
      expect(page).to have_flash(:info, text: devise_registrations_updated_msg)
    end

    it 'not update cpf and email' do
      attributes = attributes_for(:user)

      fill_in 'user_email', with: attributes[:alternative_email]
      fill_in 'user_cpf', with: attributes[:cpf]
      fill_in 'user_current_password', with: '123456'
      submit_form

      expect(page).to have_current_path(admin_edit_user_registration_path)
      expect(page).to have_flash(:info, text: devise_registrations_updated_msg)

      expect(page).to have_field('user_name', with: user.name)
      expect(page).to have_field('user_cpf', with: user.cpf)
    end
  end

  context 'with invalid fields' do
    it 'show errors' do
      fill_in 'user_name', with: ''
      fill_in 'user_alternative_email', with: 'a'
      fill_in 'user_registration_number', with: ''
      fill_in 'user_current_password', with: '123456'
      submit_form

      expect(page).to have_flash('danger', text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.user_name')
      expect(page).to have_message(sf_invalid_error_msg, in: 'div.user_alternative_email')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.user_registration_number')
    end
  end
end
