require "test_helper"

class WorkoutSessionTest < ActiveSupport::TestCase
  test "is valid with a name and workout_cycle" do
    cycle = workout_cycles(:base_strength)
    session = WorkoutSession.new(name: "Test Session", workout_cycle: cycle)
    assert session.valid?
  end

  test "is invalid without a name" do
    cycle = workout_cycles(:base_strength)
    session = WorkoutSession.new(workout_cycle: cycle)
    assert_not session.valid?
    assert_includes session.errors[:name], "can't be blank"
  end

  test "is invalid without a workout_cycle" do
    session = WorkoutSession.new(name: "Test Session")
    assert_not session.valid?
    assert_includes session.errors[:workout_cycle], "must exist"
  end

  test "belongs to workout cycle" do
    session = workout_sessions(:fb_a_squat_focus)
    assert_equal workout_cycles(:base_strength), session.workout_cycle
  end

  test "has many workout exercises" do
    session = workout_sessions(:fb_a_squat_focus)
    assert_respond_to session, :workout_exercises
    assert_includes session.workout_exercises, workout_exercises(:fb_a_back_squat)
  end

  test "destroying session destroys dependent exercises" do
    session = workout_sessions(:fb_a_squat_focus)
    exercise_count = session.workout_exercises.count
    assert exercise_count > 0

    assert_difference "WorkoutExercise.count", -exercise_count do
      session.destroy
    end
  end
end
