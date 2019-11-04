require 'rails_helper'

describe 'Staff::Documents::search', type: :feature do
  let(:staff) { create(:user) }
  let(:resource_name) { Document.model_name.human.downcase }
  let(:resource_name_plural) { I18n.t('views.names.document.plural').downcase }
  let!(:department) { create(:department) }
  let!(:manager) { create(:role, :manager) }
  let!(:division) { create(:division, department_id: department.id) }
  let!(:document) { create(:document, title: 'teste', division: division) }
  let!(:documents) { create_list(:document, 3, title: 'title', division: division) }

  before(:each) do
    create(:department_users,
           department: department,
           user: staff,
           role: manager)
    login_as(staff, scope: :user)
  end

  context 'with data' do
    it 'search an unique field' do
      visit staff_department_division_documents_search_path(department, division, document.title)

      expect(page.html).to include(pagination_one_entry)

      expect(page).to have_content(document.title)

      expect(page).to have_link(href: staff_department_division_document_path(department,
                                                                              division,
                                                                              document),
                                count: 2)
      expect(page).to have_link(href: edit_staff_department_division_document_path(department,
                                                                                   division,
                                                                                   document))
    end

    it 'search an document using common name' do
      visit staff_department_division_documents_search_path(department, division, 'title')

      expect(page.html).to include(pagination_total_entries(count: 3))

      documents.each do |document|
        expect(page).to have_content(document.title)

        expect(page).to have_link(href: staff_department_division_document_path(department,
                                                                                division,
                                                                                document),
                                  count: 2)
        expect(page).to have_link(href: edit_staff_department_division_document_path(department,
                                                                                     division,
                                                                                     document))
      end
    end

    it 'search with no existent term' do
      visit staff_department_division_documents_search_path(department,
                                                            division,
                                                            'no-existent-term')

      expect(page.html).to include('0 documentos encontrado')
    end
  end

  context 'with no data' do
    it 'show all documents' do
      visit staff_department_division_documents_search_path(department, division, '')

      expect(page.html).to include(pagination_total_entries(count: 4))

      documents.each do |document|
        expect(page).to have_content(document.title)

        expect(page).to have_link(href: staff_department_division_document_path(department,
                                                                                division,
                                                                                document),
                                  count: 2)
        expect(page).to have_link(href: edit_staff_department_division_document_path(department,
                                                                                     division,
                                                                                     document))
      end
    end
  end
end
