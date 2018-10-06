require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) {create(:user)}
  let(:user_invalid) {build(:user_invalid)}


  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is invalid with invalid attributes" do
    expect(user_invalid).to_not be_valid
  end

  context "validations" do

    it {expect(user).to validate_presence_of(:name)}
    it {expect(user).to validate_presence_of(:cpf)}
    it {expect(user).to validate_presence_of(:registration_number)}
    it {expect(user).to validate_presence_of(:username)}

    it {expect(user).to validate_uniqueness_of(:registration_number).case_insensitive}
    it {expect(user).to validate_uniqueness_of(:cpf).case_insensitive}
    it {expect(user).to validate_uniqueness_of(:username)}

    it {expect(user).to validate_length_of(:cpf).is_equal_to(11)}

  end


  it "is validation of the cpf attribute" do
    user_invalid.valid?
    expect(user_invalid.errors[:cpf]).to include("não é válido")
  end

  it "returns users by name" do
    u = User.search(user.name)
    expect(user.name).to eq(u[0].name)
  end
  it "returns users by email" do
    u = User.search(user.email)
    expect(user.email).to eq(u[0].email)
  end
  it "returns users by alternative email" do
    u = User.search(user.alternative_email)
    expect(user.alternative_email).to eq(u[0].alternative_email)
  end

end
