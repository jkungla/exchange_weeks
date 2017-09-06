require 'rails_helper'

RSpec.describe Calculation, type: :model do
  before :each do
    @calculation = Calculation.new(
        base: '',
        target: '',
        amount: '',
        wait_time: ''
    )
  end
  it 'validate' do
    expect(@calculation.valid?).to be_falsy
    expect(@calculation.errors.full_messages.first).to eq("can't be blank")

    @calculation.base = 'EUR'
    expect(@calculation.valid?).to be_falsy
    expect(@calculation.errors.full_messages.first).to eq("Target can't be blank")

    @calculation.target = 'USD'
    expect(@calculation.valid?).to be_falsy
    expect(@calculation.errors.full_messages.first).to eq("Amount is not a number")

    @calculation.amount = 10000
    expect(@calculation.valid?).to be_falsy
    expect(@calculation.errors.full_messages.first).to eq("Wait time is not included in the list")

    @calculation.wait_time = 10
    expect(@calculation.valid?).to be_truthy
  end
end
