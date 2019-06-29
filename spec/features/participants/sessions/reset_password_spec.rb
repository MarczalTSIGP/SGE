require 'rails_helper'

RSpec.describe 'Participants::Devise::Sessions', type: :feature do
  let(:user) { create(:client) }

  describe 'reset password' do
    context 'with valid email' do
      it 'update password' do
        visit new_client_password_path(user)
        fill_in 'client_email', with: user.email

        expect do
          submit_form
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        token = user.send(:set_reset_password_token)
        visit edit_client_password_url(reset_password_token: token)

        fill_in 'client_password', with: 'Passw0rd!'
        fill_in 'client_password_confirmation', with: 'Passw0rd!'
        submit_form

        expect(page).to have_current_path(participants_root_path)
        expect(page).to have_flash(:info, text: devise_password_updated_msg)
      end

      it 'not update password with invalid data' do
        token = user.send(:set_reset_password_token)
        visit edit_client_password_url(reset_password_token: token)

        fill_in 'client_password', with: ''
        fill_in 'client_password_confirmation', with: '123'
        submit_form

        expect(page).to have_current_path(client_password_path)
        expect(page).to have_flash(:danger, text: flash_errors_msg)
        expect(page).to have_message(sf_blank_error_msg, in: 'div.client_password')

        fill_in 'client_password', with: '12'
        fill_in 'client_password_confirmation', with: '123'
        submit_form

        expect(page).to have_message(sf_minimum_pwd_length, in: 'div.client_password')
        expect(page).to have_message(sf_confirmation_pwd_error_msg,
                                     in: 'div.client_password_confirmation')
      end

      it 'not update password with invalid token' do
        visit edit_client_password_url(reset_password_token: 'aaa')
        submit_form

        expect(page).to have_message(sf_invalid_error_msg, in: 'div.client_reset_password_token')
      end
    end

    context 'with invalid email' do
      it 'not send email' do
        visit new_client_password_path(user)
        fill_in 'client_email', with: 'a@abc.com'
        submit_form

        expect(page).to have_current_path(client_password_path)
        expect(page).to have_flash(:danger, text: flash_errors_msg)
        expect(page).to have_message(sf_not_found_msg, in: 'div.client_email')
      end
    end
  end
end
