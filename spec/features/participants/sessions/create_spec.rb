require 'rails_helper'

RSpec.describe 'Participants::Devise::Sessions', type: :feature do
  let!(:client) { create(:client) }

  describe '#create' do
    before(:each) do
      visit new_client_session_path
    end

    context 'with valid client' do
      it 'login by client CPF' do
        fill_in id: 'client_login', with: client.cpf
        fill_in id: 'client_password', with: client.password
        submit_form

        expect(page).to have_current_path(participants_root_path)
        expect(page).to have_flash(:info, text: devise_signed_in_msg)
      end

      it 'login by email' do
        fill_in id: 'client_login', with: client.email
        fill_in id: 'client_password', with: client.password
        submit_form

        expect(page).to have_current_path(participants_root_path)
        expect(page).to have_flash(:info, text: devise_signed_in_msg)
      end
    end

    context 'with invalid client' do
      it 'not login by CPF' do
        fill_in id: 'client_login', with: '50042543894'
        fill_in id: 'client_password', with: '123'
        submit_form

        expect(page).to have_current_path(new_client_session_path)
        expect(page).to have_flash(:warning, text: devise_invalid_sign_in_msg)
      end

      it 'not login by email' do
        fill_in id: 'client_login', with: 'test2@utfpr.edu.br'
        fill_in id: 'client_password', with: '1235'
        submit_form

        expect(page).to have_current_path(new_client_session_path)
        expect(page).to have_flash(:warning, text: devise_invalid_sign_in_msg)
      end
    end
  end
end
