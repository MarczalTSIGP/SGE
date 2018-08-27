require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    administrador = create(:role)
    @user1 = create(:'user.rb', role: administrador)

  end

  it "is valid with valid attributes" do
    expect(@user1).to be_valid
  end

  it "is invalid with invalid attributes" do
    user2 = build(:'user.rb')
    expect(user2).to_not be_valid
  end

  context "validations" do
    it {should have_db_index(:username).unique(true)}
    it {should have_db_index(:registration_number).unique(true)}

    it {should have_db_index(:cpf).unique(true)}
    it {should have_db_column(:cpf).of_type(:integer).with_options(length: 14)}

    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_presence_of(:cpf)}
    it {is_expected.to validate_presence_of(:registration_number)}
    it {is_expected.to validate_presence_of(:username)}

  end
end
