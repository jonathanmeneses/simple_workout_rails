require 'rails_helper'

describe WorkoutCycle, type: :model do
  let(:program) { WorkoutProgram.create!(name: 'Strength 101') }

  it 'is valid with a name and workout_program' do
    cycle = WorkoutCycle.new(name: 'Cycle 1', workout_program: program)
    expect(cycle).to be_valid
  end

  it 'is invalid without a name' do
    cycle = WorkoutCycle.new(workout_program: program)
    expect(cycle).not_to be_valid
  end
end
