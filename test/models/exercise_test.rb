require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "is valid with a name and movement_pattern" do
    movement_pattern = MovementPattern.create!(name: "Squat")
    exercise = Exercise.new(name: "Back Squat", movement_pattern: movement_pattern)
    assert exercise.valid?
  end

  test "is invalid without a name" do
    movement_pattern = MovementPattern.create!(name: "Squat")
    exercise = Exercise.new(movement_pattern: movement_pattern)
    assert_not exercise.valid?
  end
end
