require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full title' do
    it 'defaulf' do
      expect(helper.full_title).to eql('SGE')
    end
    it 'title' do
      expect(helper.full_title('Home')).to eql('Home | SGE')
    end
  end

  describe 'flash' do
    it 'success to bootstrap class alert' do
      expect(helper.bootstrap_class_for('success')).to eql('alert-success')
    end
    it 'error to bootstrap class alert' do
      expect(helper.bootstrap_class_for('error')).to eql('alert-danger')
    end
    it 'alert to bootstrap class alert' do
      expect(helper.bootstrap_class_for('alert')).to eql('alert-warning')
    end
    it 'notice to bootstrap class alert' do
      expect(helper.bootstrap_class_for('notice')).to eql('alert-info')
    end
    it 'any other to same bootstrap class alert' do
      expect(helper.bootstrap_class_for('danger')).to eql('danger')
    end
  end

  describe '#sub_hash_fields_document' do
    let!(:document_client) { create(:document_clients) }

    it do
      doc = sub_hash_fields_document(document_client.document,
                                     'front',
                                     document_client.cpf)

      expect(doc).to eql('MyString ' + document_client.information['name'])
    end
  end
end
