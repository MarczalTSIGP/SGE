require 'rails_helper'

describe 'Staff::DocumentClients::destroy', type: :feature do
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
  end

  describe '#destroy' do
    context 'when document is destroyed' do
      it 'show success message' do
        visit staff_department_division_document_document_clients_path(department,
                                                                       division,
                                                                       document)
        click_on_link(staff_department_division_document_document_client_path(department,
                                                              division,
                                                              document,
                                                              doc_client),
                      method: :delete)

        expect(page).to have_current_path(staff_department_division_document_document_clients_path(
                                            department,
                                            division,
                                            document))
        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))
        within('table tbody') do
          expect(page).not_to have_content(doc_client.cpf)
        end
      end
    end
  end
end
