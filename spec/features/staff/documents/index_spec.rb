require 'rails_helper'

describe 'Staff::Documents::index', type: :feature do
  let(:staff) { create(:user) }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:documents) { create_list(:document, 3, title: 'title', division: division) }

  before(:each) do
    create(:department_users,
           department_id: department.id,
           user_id: staff.id,
           role_id: manager.id)
    login_as(staff, scope: :user)
  end

  context 'with data' do
    it 'showed' do
      visit staff_documents_path
      within('table tbody') do
        documents.each do |document|
          expect(page).to have_content(document.title)

          expect(page).to have_link(href: staff_document_path(document),
                                    count: 2)
          expect(page).to have_link(href: edit_staff_document_path(document))
        end
      end
    end
  end
end
