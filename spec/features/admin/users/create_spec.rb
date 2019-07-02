require 'rails_helper'

describe 'Admin::Users::create', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { User.model_name.human }

  before(:each) do
    login_as(admin, scope: :user)
    visit new_admin_user_path
  end

  context 'with valid fields' do
    it 'create an user' do
      attributes = attributes_for(:user)

      fill_in 'user_name', with: attributes[:name]
      fill_in 'user_cpf', with: attributes[:cpf]
      fill_in 'user_username', with: attributes[:username]
      fill_in 'user_alternative_email', with: attributes[:alternative_email]
      fill_in 'user_registration_number', with: attributes[:registration_number]
      submit_form

      expect(page).to have_current_path admin_users_path
      expect(page).to have_flash(:success, text: flash_msg('create.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:name])
        expect(page).to have_content("#{attributes[:username]}@utfpr.edu.br")
        expect(page).to have_content(I18n.t('views.boolean.true'))
        expect(page).to have_content(I18n.t('views.boolean.false'))
      end
    end
  end

  context 'with fields' do
    it 'filled blank show errors' do
      submit_form

      expect(page).to have_flash(:danger, text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.user_name')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.user_cpf')
      expect(page).to have_message(sf_invalid_error_msg, in: 'div.user_cpf')
      expect(page).to have_message(sf_invalid_error_msg, in: 'div.user_username')
      expect(page).to have_message(sf_blank_error_msg, in: 'div.user_registration_number')
    end

    it 'alternative email invalid' do
      fill_in 'user_alternative_email', with: 'email'
      submit_form

      expect(page).to have_message(sf_invalid_error_msg, in: 'div.user_alternative_email')
    end
  end
end
