require "test_helper"

class WorkoutProgramTest < ActiveSupport::TestCase
  test "is valid with a name" do
    program = WorkoutProgram.new(name: "Strength 101", program_type: :full_body_3_day)
    assert program.valid?
  end

  test "is invalid without a name" do
    program = WorkoutProgram.new(program_type: :full_body_3_day)
    assert_not program.valid?
    assert_includes program.errors[:name], "can't be blank"
  end

  test "has program type enum" do
    program = workout_programs(:three_day_full_body)
    assert_equal "full_body_3_day", program.program_type
    assert program.full_body_3_day?
  end

  test "has many workout cycles" do
    program = workout_programs(:three_day_full_body)
    assert_respond_to program, :workout_cycles
    assert_includes program.workout_cycles, workout_cycles(:base_strength)
  end

  test "has many workout sessions through cycles" do
    program = workout_programs(:three_day_full_body)
    assert_respond_to program, :workout_sessions
    assert_includes program.workout_sessions, workout_sessions(:fb_a_squat_focus)
  end

  test "destroying program destroys dependent cycles" do
    program = workout_programs(:three_day_full_body)
    cycle_count = program.workout_cycles.count
    assert cycle_count > 0

    assert_difference "WorkoutCycle.count", -cycle_count do
      program.destroy
    end
  end
end
