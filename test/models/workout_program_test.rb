require "test_helper"

class WorkoutProgramTest < ActiveSupport::TestCase
  test "is valid with a name" do
    program = WorkoutProgram.new(name: "Strength 101")
    assert program.valid?
  end

  test "is invalid without a name" do
    program = WorkoutProgram.new
    assert_not program.valid?
  end
end
