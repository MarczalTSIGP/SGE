require 'rails_helper'

RSpec.describe Department, type: :model do

  before do
    @department = create(:department)
  end

  it "should be valid" do
    expect(@department).to be_valid
  end

  it "should have a valid name" do
    @department.name = "  "
    expect(@department).to_not be_valid
  end

  it "should have a valid name" do
    @department.initials = " "
    expect(@department).to_not be_valid
  end

  it "should have a valid length for initials" do
    @department.initials = "d"
    expect(@department).to_not be_valid
  end

  it "should have a valid phone" do
    @department.phone = " "
    expect(@department).to_not be_valid
  end

  it "should have a valid length for phone" do
    @department.phone = "44445555"
    expect(@department).to_not be_valid
  end

  it "department email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @department.email = valid_address
      expect(@department).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it "department email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @department.email = invalid_address
      expect(@department).to_not be_valid, "#{invalid_address.inspect} should be invalid"
    end
  end
end
