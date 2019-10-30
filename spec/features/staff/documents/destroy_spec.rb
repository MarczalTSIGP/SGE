require 'rails_helper'

describe 'Staff::Documents::destroy', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { Document.model_name.human }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:document) { create(:document, division: division) }

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
        visit staff_department_division_documents_path(department, division)
        click_on_link(staff_department_division_document_path(department, division, document),
                      method: :delete)

        expect(page).to have_current_path staff_department_division_documents_path(department,
                                                                                   division)
        expect(page).to have_flash(:success, text: flash_msg('destroy.m'))
        within('table tbody') do
          expect(page).not_to have_content(document.title)
        end
      end
    end
  end
end
