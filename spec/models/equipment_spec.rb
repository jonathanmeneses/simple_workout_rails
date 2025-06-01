require 'rails_helper'

describe Equipment, type: :model do
  it 'is valid with a name' do
    equipment = Equipment.new(name: 'Barbell')
    expect(equipment).to be_valid
  end

  it 'is invalid without a name' do
    equipment = Equipment.new
    expect(equipment).not_to be_valid
  end
end
