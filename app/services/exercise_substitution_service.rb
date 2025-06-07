class ExerciseSubstitutionService
  attr_reader :exercise, :user_equipment, :max_results

  def initialize(exercise, user_equipment: nil, max_results: 5)
    @exercise = exercise
    @user_equipment = user_equipment
    @max_results = max_results
  end

  def call
    find_substitutes
  end

  # Class method for convenience
  def self.call(exercise, **options)
    new(exercise, **options).call
  end

  private

  def find_substitutes
    base_query = Exercise.where.not(id: exercise.id)

    # Apply equipment filter to all candidates if provided
    if user_equipment&.any?
      base_query = base_query.where("equipment_required ?| array[:equipment]", equipment: user_equipment)
    end

    # Same movement pattern candidates (highest priority)
    same_movement = base_query.where(movement_pattern: exercise.movement_pattern)

    # Cross-pattern candidates with muscle/training effect overlap
    cross_pattern = build_cross_pattern_query(base_query)

    # Combine results: prioritize same movement pattern, include some cross-pattern
    combine_results(same_movement, cross_pattern)
  end

  def build_cross_pattern_query(base_query)
    cross_pattern = base_query.where.not(movement_pattern: exercise.movement_pattern)

    # Filter cross-pattern by muscle or training effect overlap
    if exercise.primary_muscles&.any?
      cross_pattern = cross_pattern.where("primary_muscles ?| array[:muscles]", muscles: exercise.primary_muscles)
    elsif exercise.training_effects&.any?
      cross_pattern = cross_pattern.where("training_effects ?| array[:effects]", effects: exercise.training_effects)
    end

    cross_pattern
  end

  def combine_results(same_movement, cross_pattern)
    results = []

    if same_movement.exists?
      # Show most same-movement-pattern options, plus 1-2 cross-pattern
      same_movement_limit = [ max_results - 2, 3 ].max
      results += same_movement.order(:complexity_level, effectiveness_score: :desc).limit(same_movement_limit)

      remaining_slots = max_results - results.length
      if remaining_slots > 0 && cross_pattern.exists?
        results += cross_pattern.order(effectiveness_score: :desc).limit(remaining_slots)
      end
    else
      # No same movement pattern - show more cross-pattern alternatives
      results = cross_pattern.order(effectiveness_score: :desc).limit(max_results)
    end

    results
  end
end
