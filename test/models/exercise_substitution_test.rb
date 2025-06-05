require 'test_helper'

class ExerciseSubstitutionTest < ActiveSupport::TestCase
  test "exercise substitution is valid with valid attributes" do
    substitution = exercise_substitutions(:back_squat_to_goblet_squat)
    assert substitution.valid?
  end

  test "exercise substitution belongs to original and alternative exercises" do
    substitution = exercise_substitutions(:back_squat_to_goblet_squat)
    assert_not_nil substitution.original_exercise
    assert_not_nil substitution.alternative_exercise
  end

  test "exercise substitution validates compatibility score range" do
    substitution = exercise_substitutions(:back_squat_to_goblet_squat)
    
    substitution.compatibility_score = 11
    assert_not substitution.valid?
    assert_includes substitution.errors[:compatibility_score], "must be between 1 and 10"
    
    substitution.compatibility_score = 0
    assert_not substitution.valid?
    assert_includes substitution.errors[:compatibility_score], "must be between 1 and 10"
    
    substitution.compatibility_score = 5
    assert substitution.valid?
  end

  test "exercise substitution prevents self-referential relationships" do
    exercise = exercises(:back_squat)
    substitution = ExerciseSubstitution.new(
      original_exercise: exercise,
      alternative_exercise: exercise,
      compatibility_score: 5
    )
    
    assert_not substitution.valid?
    assert_includes substitution.errors[:alternative_exercise], "cannot be the same as original exercise"
  end
end