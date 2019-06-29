require 'rails_helper'

describe 'Participants::Registrations::create', type: :feature do
  let(:resource_name) { Client.model_name.human }
  let(:client) { build(:client) }

  before(:each) do
    visit new_client_registration_path
  end

  context 'with invalid fields' do
    it 'show errors' do
      submit_form

      expect(page).to have_message(sf_blank_error_msg, in: 'div.client_name')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.client_cpf')
      expect(page).to have_message(sf_invalid_error_msg, in: 'div.client_cpf')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.client_email')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.client_kind')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.client_password')

      expect(page).to have_flash('danger', text: flash_errors_msg)
    end

    it 'show errors for email and alternative email' do
      fill_in 'client_email', with: 'a@'
      fill_in 'client_alternative_email', with: '@a'
      click_button

      expect(page).to have_message(sf_invalid_error_msg, in: 'div.client_email')
      expect(page).to have_message(sf_invalid_error_msg, in: 'div.client_alternative_email')

      expect(page).to have_flash('danger', text: flash_errors_msg)
    end

    it 'show errors for password confirmation' do
      fill_in 'client_password', with: '12'
      fill_in 'client_password_confirmation', with: '123'
      submit_form

      expect(page).to have_message(sf_minimum_pwd_length, in: 'div.client_password')
      expect(page).to have_message(sf_confirmation_pwd_error_msg,
                                   in: 'div.client_password_confirmation')

      expect(page).to have_flash('danger', text: flash_errors_msg)
    end
  end

  context 'with valid fields' do
    it 'register a client and sign in' do
      fill_in id: 'client_name', with: client.name
      fill_in id: 'client_cpf', with: client.cpf
      fill_in id: 'client_email', with: client.email
      fill_in id: 'client_alternative_email', with: client.alternative_email
      choose 'client_kind_external', visible: false
      fill_in id: 'client_password', with: client.password
      fill_in id: 'client_password_confirmation', with: client.password_confirmation
      submit_form

      expect(page).to have_current_path(participants_root_path)
      expect(page).to have_flash(:info, text: devise_signed_up_msg)
    end
  end
end
