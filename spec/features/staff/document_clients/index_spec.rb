require 'rails_helper'

describe 'Staff::DocumentClients::index', type: :feature do
  let(:staff) { create(:user) }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:document) { create(:document, title: 'title', division: division) }
  let!(:document2) { create(:document, :request_signature) }
  let(:doc_user) { create(:document_users, document: document, user: staff) }
  let!(:doc_clients) { create_list(:document_clients, 3, document: document) }

  before(:each) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
    login_as(staff, scope: :user)
    visit staff_department_division_document_document_clients_path(department, division, document)
  end

  context 'with data' do
    it 'showed' do
      visit staff_department_division_document_document_clients_path(department,
                                                                     division,
                                                                     document)
      within('table tbody') do
        doc_clients.each do |doc_client|
          expect(page).to have_content(doc_client.cpf)

          expect(page).to have_link(href:
                                      staff_department_division_document_document_client_path(
                                        department, division, document, doc_client
                                      ),
                                    count: 2)
          expect(page).to have_link(href:
                                      edit_staff_department_division_document_document_client_path(
                                        department, division, document, doc_client
                                      ))
        end
      end
    end

    it 'not permission' do
      visit staff_department_division_document_document_clients_path(department,
                                                                     division,
                                                                     document2)
      expect(page).to have_current_path(staff_department_division_documents_path(
                                          department,
                                          division
                                        ))
      expect(page).to have_flash(:warning,
                                 text: I18n.t('views.pages.document.request_signature.true'))
    end
  end
end
