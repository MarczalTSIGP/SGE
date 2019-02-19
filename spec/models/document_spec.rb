require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'validations' do
    context 'when shoulda matchers do' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:activity) }
    end

    context 'with associations' do
      it { is_expected.to have_many(:users_documents) }
      it { is_expected.to have_many(:users).through(:users_documents) }

      it { is_expected.to have_many(:clients_documents) }
      it { is_expected.to have_many(:clients).through(:clients_documents) }
    end
  end
end
