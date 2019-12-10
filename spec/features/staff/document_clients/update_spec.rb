require 'rails_helper'

describe 'Staff::DocumentClients::update', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { DocumentClient.model_name.human }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:document) { create(:document, title: 'title', division: division) }
  let!(:doc_user) { create(:document_users, document: document, user: staff) }
  let!(:doc_client) { create(:document_clients, document: document) }

  before(:each) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
    login_as(staff, scope: :user)
    visit edit_staff_department_division_document_document_client_path(department,
                                                                       division,
                                                                       document,
                                                                       doc_client)
  end

  context 'when render edit' do
    it 'fields should be filled' do
      expect(page).to have_field('document_client_cpf', with: doc_client.cpf)
      expect(page).to have_field('document_client_information_name',
                                 with: doc_client.information['name'])
    end
  end

  context 'with valid fields' do
    it 'update contact' do
      attributes = attributes_for(:document_clients)

      fill_in 'document_client_cpf', with: attributes[:cpf]
      fill_in 'document_client_information_name', with: attributes[:information]['name']
      submit_form

      expect(page).to have_current_path(staff_department_division_document_document_clients_path(
                                          department,
                                          division,
                                          document))
      expect(page).to have_flash(:success, text: flash_msg('update.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:cpf])
      end
    end
  end

  context 'with invalids fields' do
    it 'show errors when fields are blank' do
      fill_in 'document_client_cpf', with: ''

      submit_form

      expect(page).to have_flash(:danger, text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.document_client_cpf')

    end
  end
end
