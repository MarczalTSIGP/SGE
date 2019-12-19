require 'rails_helper'

RSpec.describe DocumentClient, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:document) }
  end

  describe '.search' do
    let!(:document_client) { create(:document_clients) }

    context 'without params' do
      it 'returns document clients by cpf' do
        doc_clients = DocumentClient.search(nil)
        expect(doc_clients.first.cpf).to eq(document_client.cpf)
      end
    end

    context 'with attributes' do
      it 'returns document clients by cpf' do
        doc_clients = DocumentClient.search(document_client.cpf)
        expect(doc_clients.first.cpf).to eq(document_client.cpf)
      end
    end
  end

  describe '#import' do
    let(:document) { create(:document) }

    it 'valid' do
      file = File.open 'spec/samples/csv/file.csv'
      expect(DocumentClient.count).to eq(0)
      DocumentClient.import(file, document.id)
      expect(DocumentClient.count).to eq(2)
    end
  end
end
