require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validations' do
    context 'when matchers' do
      subject { create(:client) }

      it { is_expected.to validate_presence_of(:name) }
    end

    context 'when CPF' do
      let(:user) { build(:user) }

      it 'validation should reject invalid cpf' do
        invalid_cpfs = %w[11823018764 2542235244 44958740546 82892290105 846141879397
                          814226380710 72986516599 08241697132 55091891497 416355172335]
        invalid_cpfs.each do |invalid_cpf|
          user.cpf = invalid_cpf
          expect(user.valid?).to((be false), "#{invalid_cpf.inspect} should be invalid")
          expect(user.errors[:cpf]).not_to be_empty
        end
      end

      it 'validation should accept valid cpf' do
        valid_cpfs = %w[15823018754 25402235244 34958740546 82892090105 84641879397
                        81422638073 62986516599 08242697132 55099891497 46355172335]

        valid_cpfs.each do |valid_cpf|
          user.cpf = valid_cpf
          expect(user.valid?).to((be true), "#{valid_cpf.inspect} should be valid")
          expect(user.errors[:cpf]).to be_empty
        end
      end
    end
  end
end
