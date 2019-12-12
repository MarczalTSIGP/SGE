require 'rails_helper'

describe 'Participants::Documents::show', type: :feature do
  let(:user) { create(:user) }
  let(:participant) { create(:client) }
  let!(:department) { create(:department) }
  let!(:division) { create(:division, department: department) }
  let!(:document) { create(:document, :request_signature, division: division) }
  let!(:document2) { create(:document) }
  let!(:doc_user) { create(:document_users, :signed, user: user, document: document) }
  let!(:doc_client) { create(:document_clients, document: document, cpf: participant.cpf) }

  context 'with data' do
    it 'showed ' do
      login_as(participant, scope: :client)
      visit participants_document_path(document)

      expect(page).to have_content('MyString ' + doc_client.information['name'])
      expect(page).to have_content(document.back)
      expect(page).to have_content(doc_user.user.name)
    end

    it 'showed not document' do
      login_as(participant, scope: :client)

      visit participants_document_path(document2)

      expect(page).to have_flash(:info, text: 'Não foi encontrado documento')
    end
  end
end
