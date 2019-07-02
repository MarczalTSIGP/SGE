require 'rails_helper'

RSpec.describe Faker::CPF do
  it 'valid' do
    cpf = described_class.numeric
    user = build(:user, cpf: cpf)

    expect(user.valid?).to be true
  end

  it 'pretty' do
    cpf = described_class.pretty
    user = build(:user, cpf: cpf)

    expect(user.valid?).to be true
    expect(user.cpf.pretty).to eql(cpf)
  end
end
