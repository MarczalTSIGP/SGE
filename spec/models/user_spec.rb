require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user1 = create(:user)
    @user_invalid = build(:user_invalid)
  end

  it "is valid with valid attributes" do
    expect(@user1).to be_valid
  end

  it "is invalid with invalid attributes" do
    expect(@user_invalid).to_not be_valid
  end

  context "validations" do
    it {should have_db_index(:username).unique(true)}
    it {should have_db_index(:registration_number).unique(true)}

    it {should have_db_index(:cpf).unique(true)}
    it {should have_db_column(:cpf).of_type(:string).with_options(length: 11)}

    it {expect(@user1).to validate_presence_of(:name)}
    it {expect(@user1).to validate_presence_of(:cpf)}
    it {expect(@user1).to validate_presence_of(:registration_number)}
    it {expect(@user1).to validate_presence_of(:username)}
  end

  it "is validation of the cpf attribute" do
    @user_invalid.valid?
    expect(@user_invalid.errors[:cpf]).to include("inválido")
  end

end
