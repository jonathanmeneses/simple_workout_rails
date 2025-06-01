require 'rails_helper'

describe Exercise, type: :model do
  let(:movement_pattern) { MovementPattern.create!(name: 'Squat') }

  it 'is valid with a name and movement_pattern' do
    exercise = Exercise.new(name: 'Back Squat', movement_pattern: movement_pattern)
    expect(exercise).to be_valid
  end

  it 'is invalid without a name' do
    exercise = Exercise.new(movement_pattern: movement_pattern)
    expect(exercise).not_to be_valid
  end
end
