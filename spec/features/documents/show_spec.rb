require 'rails_helper'

describe 'Documents::show', type: :feature do
  let(:user) { create(:user) }
  let(:participant) { create(:client) }
  let!(:department) { create(:department) }
  let!(:division) { create(:division, department: department) }
  let!(:document) { create(:document, division: division) }
  let!(:doc_user) { create(:document_users, :signed, user: user, document: document) }
  let(:doc_client) { create(:document_clients, document: document, cpf: participant.cpf) }

  context 'with data' do
    it 'showed ' do
      visit document_search_path(doc_client.key_code)

      expect(page).to have_content('MyString ' + doc_client.information['name'])
      expect(page).to have_content(document.back)

      expect(page).to have_content(doc_user.user.name)
    end
  end
end
