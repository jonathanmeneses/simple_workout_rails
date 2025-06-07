require "test_helper"

class ExerciseSubstitutionServiceTest < ActiveSupport::TestCase
  fixtures :movement_patterns, :exercises

  def setup
    @bench_press = exercises(:bench_press)
    @overhead_press = exercises(:overhead_press)
  end

  test "should find substitutes for exercise" do
    service = ExerciseSubstitutionService.new(@bench_press)
    substitutes = service.call

    assert_not_empty substitutes
    assert_not_includes substitutes, @bench_press
  end

  test "should prioritize same movement pattern" do
    # Create another horizontal push exercise
    dumbbell_bench = Exercise.create!(
      name: "Dumbbell Bench Press",
      movement_pattern: @bench_press.movement_pattern,
      primary_muscles: ["chest", "triceps"],
      equipment_required: ["dumbbells"],
      effectiveness_score: 8
    )

    substitutes = ExerciseSubstitutionService.call(@bench_press, max_results: 5)
    
    # Should include the same-pattern exercise
    assert_includes substitutes, dumbbell_bench
  end

  test "should filter by equipment when provided" do
    substitutes = ExerciseSubstitutionService.call(
      @bench_press, 
      user_equipment: ["bodyweight"], 
      max_results: 5
    )

    # All returned exercises should be compatible with bodyweight
    substitutes.each do |sub|
      assert_includes sub.equipment_required, "bodyweight"
    end
  end

  test "should respect max_results parameter" do
    substitutes = ExerciseSubstitutionService.call(@bench_press, max_results: 2)
    
    assert_operator substitutes.length, :<=, 2
  end

  test "should return cross-pattern substitutes when no same-pattern exists" do
    # Create an exercise with unique movement pattern
    unique_exercise = Exercise.create!(
      name: "Unique Exercise",
      movement_pattern: movement_patterns(:core),
      primary_muscles: ["core"],
      equipment_required: ["bodyweight"],
      effectiveness_score: 5
    )

    substitutes = ExerciseSubstitutionService.call(unique_exercise)
    
    # Should still find some substitutes, even if different movement pattern
    assert_not_empty substitutes
  end

  test "class method should work" do
    substitutes = ExerciseSubstitutionService.call(@bench_press)
    
    assert_not_empty substitutes
    assert substitutes.is_a?(Array)
  end
end