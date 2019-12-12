require 'rails_helper'

RSpec.describe Participants::DocumentsHelper, type: :helper do
  describe '#sub_hash_fields' do
    let!(:client) { create(:client) }
    let!(:document_client) { create(:document_clients, cpf: client.cpf) }

    it do
      doc = sub_hash_fields(document_client.document,
                            'front',
                            client)

      expect(doc).to eql('MyString ' + document_client.information['name'])
    end
  end
end
