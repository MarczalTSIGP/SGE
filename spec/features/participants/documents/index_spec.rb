require 'rails_helper'

describe 'Participants::Documents::index', type: :feature do
  let(:user) { create(:user) }
  let(:participant) { create(:client) }
  let!(:department) { create(:department) }
  let!(:division) { create(:division, department: department) }
  let!(:document) { create(:document, :request_signature, division: division) }
  let!(:doc_user) { create(:document_users, :signed, user: user, document: document) }

  before(:each) do
    login_as(participant, scope: :client)
  end

  context 'with data' do
    it 'showed ' do
      create(:document_clients, document: document, cpf: participant.cpf)
      visit participants_documents_path
      expect(page).to have_link(href: participants_document_path(doc_user.document))
      expect(page).to have_content(document.title)
    end
    it 'not showed' do
      visit participants_documents_path

      expect(page).to have_flash(:info, text: I18n.t('views.pages.document.search.empty'))
      expect(page).not_to have_content(document.title)
    end
  end
end
