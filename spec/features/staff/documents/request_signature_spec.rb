require 'rails_helper'

describe 'Staff::Documents::request_signature', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { Document.model_name.human }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:document) { create(:document, division: division) }
  let!(:document_sign) { create(:document, division: division, request_signature: true) }

  before(:each) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
    login_as(staff, scope: :user)
  end

  describe '#request_signature' do
    context 'when document is sign' do
      it 'show success message' do
        visit staff_department_division_documents_path(department, division)
        click_on_link(staff_department_division_put_documents_request_signature_path(department,
                                                                                     division,
                                                                                     document),
                      method: :put)

        expect(page).to have_current_path staff_department_division_documents_path(department,
                                                                                   division)
        expect(page).to have_flash(:success, text: 'Sucesso solicitação de assinatura')
        within('table tbody') do
          expect(page).to have_content(document.title)
          expect(page).to have_content(I18n.t('views.boolean.true'))
        end
      end

      it 'show alert message' do
        visit staff_department_division_documents_path(department, division)
        click_on_link(staff_department_division_put_documents_request_signature_path(department,
                                                                                     division,
                                                                                     document_sign),
                      method: :put)

        expect(page).to have_current_path staff_department_division_documents_path(department,
                                                                                   division)
        expect(page).to have_flash(:warning,
                                   text: I18n.t('views.pages.document.request_signature.true'))
        within('table tbody') do
          expect(page).to have_content(document_sign.title)
          expect(page).to have_content(I18n.t('views.boolean.true'))
        end
      end
    end
  end
end
