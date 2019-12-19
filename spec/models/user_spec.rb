require 'rails_helper'
RSpec.describe User, type: :model do
  describe 'validations' do
    context 'when shoulda matchers do' do
      subject { create(:user) }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:registration_number) }
      it { is_expected.to validate_uniqueness_of(:registration_number).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:cpf).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

      it { is_expected.to allow_value('email@addresse.foo').for(:alternative_email) }
      it { is_expected.not_to allow_value('foo').for(:alternative_email) }
    end

    context 'when username' do
      let(:user) { build(:user) }

      it 'is invalid reject it' do
        invalid_usernames = ['a@a', 'a a', ' ']
        invalid_usernames.each do |invalid_username|
          user.username = invalid_username
          expect(user.valid?).to((be false), "#{invalid_username.inspect} should be invalid")
        end
      end

      it 'is valid accept it' do
        valid_usernames = ['aaa', 'abca', 'User', 'test', 'tes.t', 'user']
        valid_usernames.each do |valid_username|
          user.username = valid_username
          expect(user.valid?).to((be true), "#{valid_username.inspect} should be valid")
        end
      end

      it 'used in email' do
        user.username = 'abc'
        expect(user.username).to eql('abc')
        expect(user.email).to eql('abc@utfpr.edu.br')
      end

      it 'is invalid and used in email' do
        user.username = 'a a'
        user.valid?
        expect(user.errors.messages[:username]).to eql(user.errors.messages[:email])
      end
    end

    context 'when CPF' do
      let(:user) { build(:user) }

      it 'is invalid' do
        invalid_cpfs = %w[11823018764 2542235244 44958740546 82892290105 846141879397
                          814226380710 72986516599 08241697132 55091891497 416355172335]
        invalid_cpfs.each do |invalid_cpf|
          user.cpf = invalid_cpf
          expect(user.valid?).to((be false), "#{invalid_cpf.inspect} should be invalid")
          expect(user.errors[:cpf]).not_to be_empty
        end
      end

      it 'is valid' do
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

  describe '.search' do
    let(:user) { create(:user) }

    context 'without params' do
      it 'returns users by name' do
        users = User.search(nil)
        expect(users).to include(user)
      end
    end

    context 'with attributes' do
      it 'returns users by name' do
        users = User.search(user.name)
        expect(user.name).to eq(users.first.name)
      end

      it 'returns users by email' do
        users = User.search(user.email)
        expect(user.email).to eq(users.first.email)
      end

      it 'returns users by alternative email' do
        users = User.search(user.alternative_email)
        expect(user.alternative_email).to eq(users.first.alternative_email)
      end
    end

    context 'with accents' do
      it 'in attribute' do
        user = create(:user, name: 'Alícia')
        users = User.search('Alicia')
        expect(user.name).to eq(users.first.name)
      end

      it 'in search term' do
        user = create(:user, name: 'Alicia')
        users = User.search('Alícia')
        expect(user.name).to eq(users.first.name)
      end
    end

    context 'with ignoring case sensitive' do
      it 'in attribute' do
        user = create(:user, name: 'Ana')
        users = User.search('an')
        expect(user.name).to eq(users.first.name)
      end

      it 'in search term' do
        user = create(:user, name: 'ana')
        users = User.search('AN')
        expect(user.name).to eq(users.first.name)
      end
    end
  end

  describe '.find_and_validate_for_authentication' do
    let(:user) { create(:user) }

    it 'authenticate by username' do
      u = User.find_for_database_authentication(login: user.username)
      expect(u.valid_password?('123456')).to be true
    end

    it 'authenticate by email' do
      u = User.find_for_database_authentication(login: user.email)
      expect(u.valid_password?('123456')).to be true
    end
  end

  describe '#login' do
    let(:user) { build(:user) }

    it 'return login' do
      user.login = 'login'
      expect(user.login).to eql('login')
    end

    it 'return username' do
      user.login = nil
      user.username = 'admin'
      expect(user.login).to eql('admin')
    end

    it 'return email' do
      u = User.new email: 'admin@utfpr.edu.br'
      expect(u.login).to eql('admin@utfpr.edu.br')
    end
  end

  describe '#cpf' do
    let(:user) { build(:user, cpf: '11598829084') }

    it 'cpf' do
      expect(user.cpf).to eql('11598829084')
    end

    it 'pretty cpf' do
      expect(user.cpf.pretty).to eql('115.988.290-84')
    end

    it 'receiving a formatted cpf' do
      user.cpf = '115.988.290-84'
      expect(user.cpf).to eql('11598829084')
    end
  end

  describe '#auth' do
    let!(:user) { create(:user) }

    it 'valid' do
      response = User.auth(user.username, '123456')
      expect(user).to eql(response)
    end

    it 'invalid' do
      response = User.auth(user.username, '123')
      expect(user).not_to eql(response)
    end
  end
end
