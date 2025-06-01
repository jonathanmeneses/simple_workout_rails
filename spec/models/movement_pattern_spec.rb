require 'rails_helper'

describe MovementPattern, type: :model do
  it 'is valid with a name' do
    pattern = MovementPattern.new(name: 'Hinge')
    expect(pattern).to be_valid
  end

  it 'is invalid without a name' do
    pattern = MovementPattern.new
    expect(pattern).not_to be_valid
  end
end
