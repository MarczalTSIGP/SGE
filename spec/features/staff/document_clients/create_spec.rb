require 'rails_helper'

describe 'Staff::DocumentClients::create', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { DocumentClient.model_name.human }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:document) { create(:document, title: 'title', division: division) }
  let!(:doc_user) { create(:document_users, document: document, user: staff) }

  before(:each) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
    login_as(staff, scope: :user)
    visit new_staff_department_division_document_document_client_path(department,
                                                                      division,
                                                                      document)
  end

  context 'with valid fields' do
    it 'create an client document' do
      attributes = attributes_for(:document_clients)
      fill_in 'document_client_cpf', with: attributes[:cpf]
      fill_in 'document_client_information_name', with: attributes[:information][:name]

      submit_form

      expect(page).to have_current_path staff_department_division_document_document_clients_path(
                                          department,
                                          division,
                                          document)
      expect(page).to have_flash(:success, text: flash_msg('create.m'))

      within('table tbody') do
        expect(page).to have_content(attributes[:cpf])
      end
    end
  end

  context 'with fields' do
    it 'filled blank show errors' do
      submit_form

      expect(page).to have_flash(:danger, text: flash_errors_msg)

      expect(page).to have_message(sf_blank_error_msg, in: 'div.document_client_cpf')

    end
  end
end
