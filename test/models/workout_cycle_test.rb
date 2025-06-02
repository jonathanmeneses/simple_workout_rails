require "test_helper"

class WorkoutCycleTest < ActiveSupport::TestCase
  test "is valid with a name and workout_program" do
    program = WorkoutProgram.create!(name: "Strength 101")
    cycle = WorkoutCycle.new(name: "Cycle 1", workout_program: program)
    assert cycle.valid?
  end

  test "is invalid without a name" do
    program = WorkoutProgram.create!(name: "Strength 101")
    cycle = WorkoutCycle.new(workout_program: program)
    assert_not cycle.valid?
  end
end
