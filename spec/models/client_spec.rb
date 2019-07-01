require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'validations' do
    context 'when matchers' do
      subject { create(:client) }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:cpf) }

      it { is_expected.to validate_uniqueness_of(:cpf).case_insensitive }

      it { is_expected.to allow_value('email@addresse.foo').for(:alternative_email) }
      it { is_expected.not_to allow_value('foo').for(:alternative_email) }
    end

    context 'when CPF' do
      let(:client) { build(:client) }

      it 'validation should reject invalid cpf' do
        invalid_cpfs = %w[11823018764 2542235244 44958740546 82892290105 846141879397
                          814226380710 72986516599 08241697132 55091891497 416355172335]
        invalid_cpfs.each do |invalid_cpf|
          client.cpf = invalid_cpf
          expect(client.valid?).to((be false), "#{invalid_cpf.inspect} should be invalid")
          expect(client.errors[:cpf]).not_to be_empty
        end
      end

      it 'validation should accept valid cpf' do
        valid_cpfs = %w[15823018754 25402235244 34958740546 82892090105 84641879397
                        81422638073 62986516599 08242697132 55099891497 46355172335]

        valid_cpfs.each do |valid_cpf|
          client.cpf = valid_cpf
          expect(client.valid?).to((be true), "#{valid_cpf.inspect} should be valid")
          expect(client.errors[:cpf]).to be_empty
        end
      end
    end

    describe '.kinds' do
      subject(:client) { Client.new }

      it 'enum' do
        expect(client).to define_enum_for(:kind)
          .with_values(server: 'server', external: 'external', academic: 'academic')
          .backed_by_column_of_type(:enum)
          .with_prefix(:kind)
      end

      it 'human enum' do
        hash = { I18n.t('enums.kinds.server') => 'server',
                 I18n.t('enums.kinds.external') => 'external',
                 I18n.t('enums.kinds.academic') => 'academic' }

        expect(Client.human_kinds).to include(hash)
      end

      it 'validates presence of kind' do
        c = Client.new
        c.valid?

        expect(c.errors.messages[:kind]).to include(I18n.t('errors.messages.blank'))
      end
    end
  end

  describe '.find_and_validate_for_authentication' do
    let(:client) { create(:client) }

    it 'authenticate by cpf' do
      c = Client.find_for_database_authentication(login: client.cpf)
      expect(c.valid_password?('123456')).to be true
    end

    it 'authenticate by email' do
      c = Client.find_for_database_authentication(login: client.email)
      expect(c.valid_password?('123456')).to be true
    end
  end

  describe '#login' do
    let(:client) { build(:client) }

    it 'return login' do
      client.login = 'login'
      expect(client.login).to eql('login')
    end

    it 'return clientname' do
      client.login = nil
      client.cpf = '11598829084'
      expect(client.login).to eql('11598829084')
    end

    it 'return email' do
      c = Client.new email: 'admin@utfpr.edu.br'
      expect(c.login).to eql('admin@utfpr.edu.br')
    end
  end

  describe '#cpf' do
    let(:client) { build(:client, cpf: '11598829084') }

    it 'cpf' do
      expect(client.cpf).to eql('11598829084')
    end

    it 'pretty cpf' do
      expect(client.cpf.pretty).to eql('115.988.290-84')
    end

    it 'receiving a formatted cpf' do
      client.cpf = '115.988.290-84'
      expect(client.cpf).to eql('11598829084')
    end
  end
end
