require 'rails_helper'

describe 'Staff::Documents::show', type: :feature do
  let(:staff) { create(:user) }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department: department) }
  let!(:document) { create(:document, division: division) }
  let!(:document_diff) { create(:document) }

  before(:each) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
    login_as(staff, scope: :user)
  end

  context 'with data' do
    it 'showed ' do
      visit staff_document_path(document)

      expect(page).to have_content(document.back)
      expect(page).to have_content(document.front)
      expect(page).to have_content(document.division.name)
    end
  end

  context 'with links' do
    before(:each) do
      visit staff_document_path(document)
    end

    it do
      expect(page).to have_link(I18n.t('views.links.back'),
                                href: staff_documents_path)
    end
  end

  context 'when not permission' do
    it do
      visit staff_document_path(document_diff)
      expect(page).to have_current_path staff_documents_path
      expect(page).to have_flash(:warning, text: 'Não possui permissão')
    end
  end
end
