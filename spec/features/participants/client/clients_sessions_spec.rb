require 'rails_helper'

RSpec.feature 'Participants::Client::ClientsSessions', type: :feature do
  let!(:client) { create(:client) }

  describe '#create' do
    before(:each) do
      visit new_client_session_path
    end

    context 'with valid client' do
      it 'login by cpf' do
        fill_in id: 'client_login', with: client.cpf
        fill_in id: 'client_password', with: client.password

        submit_form

        expect(current_path).to eq(participants_root_path)
      end

      it 'login by email' do
        fill_in id: 'client_login', with: client.email
        fill_in id: 'client_password', with: client.password

        submit_form

        expect(current_path).to eq(participants_root_path)
      end
    end

    context 'with invalid client' do
      it 'not login by cpf' do
        fill_in id: 'client_login', with: '123456789'
        fill_in id: 'client_password', with: '123456'

        submit_form

        expect(page).to have_text(I18n.t('devise.failure.invalid',
                                         authentication_keys: 'Login'))
        expect(current_path).to eq(new_client_session_path)
      end

      it 'not login by email' do
        fill_in id: 'client_login', with: 'test2@utfpr.edu.br'
        fill_in id: 'client_password', with: '123456'

        submit_form

        expect(page).to have_text(I18n.t('devise.login.title'))
        expect(current_path).to eq(new_client_session_path)
      end
    end
  end
end
