require 'rails_helper'

RSpec.describe DocumentUser, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:document) }
    it { is_expected.to belong_to(:user) }
  end

  describe '#toggle_subscription' do
    let(:document_user) { create(:document_users) }

    it '#toggle_subscription' do
      DocumentUser.toggle_subscription(document_user)
      doc_user = DocumentUser.find_by(id: document_user.id)
      expect(doc_user).to eql(document_user)
    end
  end
end
