require 'rails_helper'

describe 'Admin::Users::update', type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:resource_name) { User.model_name.human }
  let(:user) { create_list(:user, 2, :inactive).sample }

  before(:each) do
    login_as(admin, scope: :user)
    visit edit_admin_user_path(user)
  end

  context 'when render edit' do
    it 'fields should be filled' do
      expect(page).to have_field('user_name', with: user.name)
      expect(page).to have_field('user_cpf', with: user.cpf)
      expect(page).to have_field('user_alternative_email', with: user.alternative_email)
      expect(page).to have_field('user_registration_number', with: user.registration_number)
      expect(page).to have_unchecked_field('user_active')
    end
  end

  context 'with valid fields' do
    it 'update contact' do
      attributes = attributes_for(:user)

      fill_in 'user_name', with: attributes[:name]
      fill_in 'user_cpf', with: attributes[:cpf]
      fill_in 'user_username', with: attributes[:username]
      fill_in 'user_alternative_email', with: attributes[:alternative_email]
      fill_in 'user_registration_number', with: attributes[:registration_number]
      check('user_active')
      submit_form

      expect(page).to have_current_path admin_users_path
      expect(page).to have_flash(:success, text: flash_msg('update.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:name])
        expect(page).to have_content("#{attributes[:username]}@utfpr.edu.br")
        expect(page).to have_content(I18n.t('views.boolean.false'))
        expect(page).to have_content(I18n.t('views.boolean.false'))
      end
    end
  end

  context 'with invalids fields' do
    it 'show errors when fields are blank' do
      fill_in 'user_name', with: ''
      fill_in 'user_cpf', with: ''
      fill_in 'user_username', with: ''
      fill_in 'user_alternative_email', with: ''
      fill_in 'user_registration_number', with: ''
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
