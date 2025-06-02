require "test_helper"

class WorkoutExerciseTest < ActiveSupport::TestCase
  test "is valid with workout_session and exercise" do
    session = workout_sessions(:fb_a_squat_focus)
    exercise = exercises(:back_squat)
    workout_exercise = WorkoutExercise.new(
      workout_session: session,
      exercise: exercise,
      sets: 3,
      reps: 10,
      order_position: 1
    )
    assert workout_exercise.valid?
  end

  test "is invalid without a workout_session" do
    exercise = exercises(:back_squat)
    workout_exercise = WorkoutExercise.new(exercise: exercise)
    assert_not workout_exercise.valid?
    assert_includes workout_exercise.errors[:workout_session], "must exist"
  end

  test "is invalid without an exercise" do
    session = workout_sessions(:fb_a_squat_focus)
    workout_exercise = WorkoutExercise.new(workout_session: session)
    assert_not workout_exercise.valid?
    assert_includes workout_exercise.errors[:exercise], "must exist"
  end

  test "belongs to workout session" do
    workout_exercise = workout_exercises(:fb_a_back_squat)
    assert_equal workout_sessions(:fb_a_squat_focus), workout_exercise.workout_session
  end

  test "belongs to exercise" do
    workout_exercise = workout_exercises(:fb_a_back_squat)
    assert_equal exercises(:back_squat), workout_exercise.exercise
  end

  test "has exercise type enum" do
    workout_exercise = workout_exercises(:fb_a_back_squat)
    assert_equal "main", workout_exercise.exercise_type
    assert workout_exercise.main?
  end

  test "can be accessory type" do
    workout_exercise = workout_exercises(:fb_a_chin_ups)
    assert_equal "accessory", workout_exercise.exercise_type
    assert workout_exercise.accessory?
  end
end