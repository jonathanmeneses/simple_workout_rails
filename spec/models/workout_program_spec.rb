require 'rails_helper'

describe WorkoutProgram, type: :model do
  it 'is valid with a name' do
    program = WorkoutProgram.new(name: 'Strength 101')
    expect(program).to be_valid
  end

  it 'is invalid without a name' do
    program = WorkoutProgram.new
    expect(program).not_to be_valid
  end
end
