require 'rails_helper'

describe 'Staff::Documents::sign', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { Document.model_name.human }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:document) { create(:document, :request_signature, division: division) }
  let!(:doc_user) { create(:document_users, document: document, user: staff) }

  before(:each) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
    login_as(staff, scope: :user)
    visit staff_user_documents_sign_path(doc_user.document)
  end

  describe '#sign' do
    context 'when document is sign' do
      it 'show success message' do
        fill_in id: 'document_login', with: staff.username
        fill_in id: 'document_password', with: staff.password

        submit_form

        expect(page).to have_flash(:success, text: I18n.t('views.pages.sign.success'))
        expect(page).to have_current_path staff_root_path
      end

      it 'show error message' do
        fill_in id: 'document_login', with: staff.username
        fill_in id: 'document_password', with: '123'

        submit_form

        expect(page).to have_flash(:warning, text: 'Erro na assinatura do documento')
        expect(page).to have_current_path staff_user_documents_sign_path(document)
      end
    end
  end
end
