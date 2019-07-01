require 'rails_helper'

describe 'Participants::Registrations::edit', type: :feature do
  let(:resource_name) { Client.model_name.human }
  let(:client) { create(:client, kind: Client.kinds[:academic]) }

  before(:each) do
    login_as(client, scope: :client)
    visit edit_client_registration_path
  end

  context 'when render edit' do
    it 'fields should be filled' do
      expect(page).to have_field('client_name', with: client.name)
      expect(page).to have_field('client_cpf', with: client.cpf)
      expect(page).to have_field('client_email', with: client.email)
      expect(page).to have_field('client_alternative_email', with: client.alternative_email)
      expect(page).to have_checked_field('client_kind_academic', visible: false)
    end
  end

  context 'with valid fields' do
    it 'update a client' do
      attributes = attributes_for(:client)

      fill_in 'client_name', with: attributes[:name]
      fill_in 'client_cpf', with: attributes[:cpf]
      fill_in 'client_email', with: attributes[:email]
      fill_in 'client_alternative_email', with: attributes[:alternative_email]
      choose 'client_kind_external', visible: false
      fill_in 'client_current_password', with: '123456'
      submit_form

      expect(page).to have_current_path(edit_client_registration_path)
      expect(page).to have_flash(:info, text: devise_registrations_updated_msg)
    end
  end

  context 'with invalid fields' do
    it 'show errors' do
      fill_in id: 'client_name', with: ''
      fill_in id: 'client_cpf', with: ''
      fill_in id: 'client_email', with: ''
      fill_in id: 'client_alternative_email', with: ''
      submit_form

      expect(page).to have_message(sf_blank_error_msg, in: 'div.client_name')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.client_cpf')
      expect(page).to have_message(sf_invalid_error_msg, in: 'div.client_cpf')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.client_email')

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
end
