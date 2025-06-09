require "test_helper"

class WorkoutCycleTest < ActiveSupport::TestCase
  test "is valid with a name and workout_program" do
    program = workout_programs(:three_day_full_body)
    cycle = WorkoutCycle.new(name: "Test Cycle", workout_program: program)
    assert cycle.valid?
  end

  test "is invalid without a name" do
    program = workout_programs(:three_day_full_body)
    cycle = WorkoutCycle.new(workout_program: program)
    assert_not cycle.valid?
    assert_includes cycle.errors[:name], "can't be blank"
  end

  test "is invalid without a workout_program" do
    cycle = WorkoutCycle.new(name: "Test Cycle")
    assert_not cycle.valid?
    assert_includes cycle.errors[:workout_program], "must exist"
  end

  test "belongs to workout program" do
    cycle = workout_cycles(:base_strength)
    assert_equal workout_programs(:three_day_full_body), cycle.workout_program
  end

  test "has many workout sessions" do
    cycle = workout_cycles(:base_strength)
    assert_respond_to cycle, :workout_sessions
    assert_includes cycle.workout_sessions, workout_sessions(:fb_a_squat_focus)
  end

  test "destroying cycle destroys dependent sessions" do
    cycle = workout_cycles(:base_strength)
    session_count = cycle.workout_sessions.count
    assert session_count > 0

    assert_difference "WorkoutSession.count", -session_count do
      cycle.destroy
    end
  end
end
