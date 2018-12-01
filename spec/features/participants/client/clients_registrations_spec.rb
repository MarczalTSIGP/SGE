require 'rails_helper'

RSpec.feature 'Participants::Client::ClientsRegistrations', type: :feature do
  describe '#create' do
    let(:client) { create(:client) }
    before(:each) do
      visit new_client_registration_path
    end

    context 'with valid client' do
      it 'academic' do
        fill_in id: 'client_name', with: client.name
        fill_in id: 'client_cpf', with: client.cpf
        fill_in id: 'client_email', with: client.email
        fill_in id: 'client_alternative_email', with: client.alternative_email
        choose 'client_kind_academic'
        fill_in id: 'client_password', with: client.password
        fill_in id: 'client_password_confirmation', with: client.password_confirmation
        submit_form

        expect(current_path).to eq(participants_root_path)
      end

      it 'external' do
        fill_in id: 'client_name', with: client.name
        fill_in id: 'client_cpf', with: client.cpf
        fill_in id: 'client_email', with: client.email
        fill_in id: 'client_alternative_email', with: client.alternative_email
        choose 'client_kind_external'
        fill_in id: 'client_password', with: client.password
        fill_in id: 'client_password_confirmation', with: client.password_confirmation
        submit_form

        expect(current_path).to eq(participants_root_path)
      end

      it 'server' do
        fill_in id: 'client_name', with: client.name
        fill_in id: 'client_cpf', with: client.cpf
        fill_in id: 'client_email', with: client.email
        fill_in id: 'client_alternative_email', with: client.alternative_email
        choose 'client_kind_server'
        fill_in id: 'client_password', with: client.password
        fill_in id: 'client_password_confirmation', with: client.password_confirmation
        submit_form

        expect(current_path).to eq(participants_root_path)
      end
    end

    context 'with invalid client' do
      it 'blank' do
        submit_form

        expect(current_path).to eq(client_registration_path)
        expect(page).to have_content('div.client_name', I18n.t('errors.messages.blank'))
        expect(page).to have_content('div.client_cpf', I18n.t('errors.messages.blank'))
        expect(page).to have_content('div.client_email', I18n.t('errors.messages.blank'))
        expect(page).to have_content 'div.client_password', I18n.t('errors.messages.blank')
        expect(page).to have_content I18n.t('errors.messages.blank'), count: 4
      end

      it 'type is not included in the list' do
        submit_form
        expect(current_path).to eq(client_registration_path)
        expect(page).to have_content I18n.t('errors.messages.inclusion'), count: 1
      end

      it 'in use' do
        fill_in id: 'client_cpf', with: client.cpf
        fill_in id: 'client_email', with: client.email

        submit_form
        expect(current_path).to eq(participants_root_path)
        expect(page).to have_content(I18n.t('errors.messages.taken'), count: 2)
      end
    end
  end

  describe '#update' do
    let!(:client) { create(:client) }
    let!(:client2) { create(:client) }

    before(:each) do
      login_as(client, scope: :client)
      visit edit_client_registration_path(client)
    end

    context 'fill fields' do
      it 'with correct values' do
        expect(page).to have_current_path(edit_client_registration_path(client))
        expect(page).to have_field id: 'client_name', with: client.name
        expect(page).to have_field 'client_email', with: client.email
        expect(page).to have_field 'client_alternative_email', with: client.alternative_email
        expect(page).to have_field 'client_cpf', with: client.cpf
      end
    end
    context 'with valid fields' do
      it 'update recommendation' do
        attributes = attributes_for(:client)
        fill_in id: 'client_name', with: attributes[:name]
        fill_in id: 'client_email', with: attributes[:email]
        fill_in id: 'client_alternative_email', with: attributes[:alternative_email]
        fill_in id: 'client_cpf', with: attributes[:cpf]
        fill_in id: 'client_password', with: '654321'
        fill_in id: 'client_password_confirmation', with: '654321'
        fill_in id: 'client_current_password', with: client.password
        submit_form
        expect(current_path).to eq(participants_root_path(client))
        expect(page).to have_content(I18n.t('devise.registrations.updated'))
      end
    end
    context 'with invalid fields' do
      it 'show blank errors' do
        fill_in id: 'client_name', with: ''
        fill_in id: 'client_email', with: ''
        fill_in id: 'client_cpf', with: ''
        submit_form
        expect(page).to have_content(I18n.t('errors.messages.blank'), count: 4)
      end

      it 'show taken errors' do
        fill_in id: 'client_email', with: client2.email
        fill_in id: 'client_cpf', with: client2.cpf
        fill_in id: 'client_alternative_email', with: client2.alternative_email
        submit_form
        expect(page).to have_content(I18n.t('errors.messages.taken'), count: 3)
        expect(current_path).to eq(participants_root_path)
      end

      it 'show invalid errors' do
        fill_in id: 'client_cpf', with: '12314124124124'
        fill_in id: 'client_alternative_email', with: '@Asdf@ASD'
        fill_in id: 'client_email', with: '@Asdf@ASD'
        submit_form
        expect(page).to have_content(I18n.t('errors.messages.invalid'), count: 3)
      end
    end
  end
end
