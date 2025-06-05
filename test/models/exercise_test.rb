require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "is valid with a name and movement_pattern" do
    movement_pattern = MovementPattern.create!(name: "Squat")
    exercise = Exercise.new(
      name: "Back Squat", 
      movement_pattern: movement_pattern,
      complexity_level: :beginner,
      effectiveness_score: 8
    )
    assert exercise.valid?
  end

  test "is invalid without a name" do
    movement_pattern = MovementPattern.create!(name: "Squat")
    exercise = Exercise.new(movement_pattern: movement_pattern)
    assert_not exercise.valid?
  end

  test "find_substitutes returns exercises with matching equipment" do
    # Create exercises with JSONB attributes
    squat_pattern = MovementPattern.create!(name: "Squat")
    original = Exercise.create!(
      name: "Barbell Back Squat",
      movement_pattern: squat_pattern,
      primary_muscles: ['quads', 'glutes'],
      equipment_required: ['barbell', 'squat_rack'],
      training_effects: ['strength'],
      complexity_level: :intermediate,
      effectiveness_score: 9
    )
    
    substitute = Exercise.create!(
      name: "Goblet Squat", 
      movement_pattern: squat_pattern,
      primary_muscles: ['quads', 'glutes'],
      equipment_required: ['dumbbells'], 
      training_effects: ['strength'],
      complexity_level: :beginner,
      effectiveness_score: 7
    )
    
    # Test equipment filtering - should find substitute when dumbbells available
    substitutes = original.find_substitutes(['dumbbells'], 5)
    assert_includes substitutes, substitute
    
    # Test equipment filtering - should not find substitute when no matching equipment
    substitutes = original.find_substitutes(['resistance_bands'], 5)
    assert_not_includes substitutes, substitute
  end

  test "find_substitutes prioritizes same movement pattern" do
    # Create movement patterns
    squat_pattern = MovementPattern.create!(name: "Squat")
    push_pattern = MovementPattern.create!(name: "Horizontal Push")
    
    original = Exercise.create!(
      name: "Back Squat",
      movement_pattern: squat_pattern,
      primary_muscles: ['quads', 'glutes'],
      equipment_required: ['barbell'],
      training_effects: ['strength'],
      complexity_level: :intermediate,
      effectiveness_score: 9
    )
    
    same_pattern = Exercise.create!(
      name: "Front Squat",
      movement_pattern: squat_pattern,
      primary_muscles: ['quads'],
      equipment_required: ['barbell'],
      training_effects: ['strength'],
      complexity_level: :intermediate,
      effectiveness_score: 8
    )
    
    different_pattern = Exercise.create!(
      name: "Push-up",
      movement_pattern: push_pattern,
      primary_muscles: ['chest'],
      equipment_required: ['bodyweight'],
      training_effects: ['strength'],
      complexity_level: :beginner,
      effectiveness_score: 6
    )
    
    substitutes = original.find_substitutes(['barbell', 'bodyweight'], 5)
    
    # Same movement pattern should be prioritized
    assert_includes substitutes, same_pattern
    # Different pattern should not be included when same pattern exists and no muscle overlap
    assert_not_includes substitutes, different_pattern
  end

  test "JSONB array validations work correctly" do
    movement_pattern = MovementPattern.create!(name: "Squat")
    
    # Valid JSONB arrays
    exercise = Exercise.new(
      name: "Test Exercise",
      movement_pattern: movement_pattern,
      primary_muscles: ['quads', 'glutes'],
      equipment_required: ['barbell'],
      training_effects: ['strength'],
      complexity_level: :beginner,
      effectiveness_score: 8
    )
    assert exercise.valid?
    
    # Invalid muscle
    exercise.primary_muscles = ['invalid_muscle']
    assert_not exercise.valid?
    assert_includes exercise.errors[:primary_muscles], "contains invalid muscles: invalid_muscle"
    
    # Invalid equipment
    exercise.primary_muscles = ['quads']
    exercise.equipment_required = ['invalid_equipment']
    assert_not exercise.valid?
    assert_includes exercise.errors[:equipment_required], "contains invalid equipment: invalid_equipment"
    
    # Invalid training effect
    exercise.equipment_required = ['barbell']
    exercise.training_effects = ['invalid_effect']
    assert_not exercise.valid?
    assert_includes exercise.errors[:training_effects], "contains invalid training effects: invalid_effect"
  end
end
