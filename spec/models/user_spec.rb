require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user1 = create(:user)
  end



  it "is valid with valid attributes" do
    expect(@user1).to be_valid
  end

  it "is invalid with invalid attributes" do
    user2 = build(:user)
    expect(user2).to_not be_valid
  end

  context "validations" do
    it {should have_db_index(:username).unique(true)}
    it {should have_db_index(:registration_number).unique(true)}

    it {should have_db_index(:cpf).unique(true)}
    it {should have_db_column(:cpf).of_type(:string).with_options(length: 11)}

    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:cpf)}
    it {should validate_presence_of(:registration_number)}
    it {should validate_presence_of(:username)}
  end


  it "is validation of the cpf attribute" do
    user2 = build(:user_invalid)
    user2.valid?
    expect(user2.errors[:cpf]).to include("CPF inválido")
  end
  it "is validation of the email institutional attribute" do
    user2 = build(:user_invalid)
    user2.valid?
    expect(user2.errors[:email]).to include("Email não institucional")
  end
end
