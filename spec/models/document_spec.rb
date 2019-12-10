require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'validations' do
    context 'when matchers' do
      subject { create(:document) }

      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:front) }
      it { is_expected.to validate_presence_of(:back) }
      it { is_expected.to validate_presence_of(:division) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:division) }
  end

  describe '.search' do
    let(:document) { create(:document) }

    context 'without params' do
      it 'returns department by name' do
        documents = Document.search(nil)
        expect(documents).to include(document)
      end
    end

    context 'with attributes' do
      it 'returns documents by title' do
        documents = Document.search(document.title)
        expect(document.title).to eq(documents.first.title)
      end
    end

    context 'with accents' do
      it 'in attribute' do
        document = create(:document, title: 'Departamento de Materiais e Patrimônio')
        documents = Document.search('Patrimonio')
        expect(document.title).to eq(documents.first.title)
      end

      it 'in search term' do
        document = create(:document, title: 'Departamento de Materiais e Patrimonio')
        documents = Document.search('Patrimônio')
        expect(document.title).to eq(documents.first.title)
      end
    end

    context 'with ignoring case sensitive' do
      it 'in attribute' do
        document = create(:document, title: 'Departamento de Materiais e Patrimonio')
        documents = Document.search('de')
        expect(document.title).to eq(documents.first.title)
      end

      it 'in search term' do
        document = create(:document, title: 'departamento de materiais e patrimonio')
        documents = Document.search('DEPAR')
        expect(document.title).to eq(documents.first.title)
      end
    end
  end

  describe '#to_csv' do
    let(:document) { create(:document) }
    let(:header) { 'cpf,name' }

    it 'generated' do
      csv = Document.to_csv(document.id)
      expect(csv.delete("\n")).to eq(header)
    end
  end
end
