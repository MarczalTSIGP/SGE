require 'rails_helper'

describe 'Staff::Documents::show', type: :feature do
  let(:staff) { create(:user) }
  let!(:department) { create(:department) }
  let!(:division2) { create(:division) }
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
      visit staff_department_division_document_path(department, division, document)

      expect(page).to have_content(document.back)
      expect(page).to have_content(document.front)
      expect(page).to have_content(document.division.name)
      document.document_users.each do |ds|
        expect(page).to have_content(ds.function)
        expect(page).to have_content(ds.user.name)
      end
    end
  end

  context 'with links' do
    before(:each) do
      visit staff_department_division_document_path(department, division, document)
    end

    it do
      expect(page).to have_link(I18n.t('views.links.back'),
                                href: staff_department_division_documents_path(department,
                                                                               division))
    end
  end

  context 'when not permission' do
    it do
      visit staff_department_division_document_path(division2.department, division2, document_diff)
      expect(page).to have_current_path staff_divisions_path
      expect(page).to have_flash(:warning, text: 'Não possui permissão documento')
    end
  end
end
