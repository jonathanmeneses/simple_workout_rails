class Exercise < ApplicationRecord
  belongs_to :movement_pattern
  # Self-referential substitution relationships
  has_many :exercise_substitutions, foreign_key: "original_exercise_id", dependent: :destroy
  has_many :alternatives, through: :exercise_substitutions, source: :alternative_exercise

  has_many :reverse_exercise_substitutions, class_name: "ExerciseSubstitution",
           foreign_key: "alternative_exercise_id", dependent: :destroy
  has_many :original_exercises, through: :reverse_exercise_substitutions, source: :original_exercise

  # Validation whitelists for JSONB arrays
  VALID_MUSCLES = %w[
    quads glutes hamstrings calves chest back lats traps rhomboids
    front_delts side_delts rear_delts triceps biceps forearms core abs obliques
  ].freeze

  VALID_EQUIPMENT = %w[
    barbell rack kettlebell dumbbell heel_wedge TRX_or_rail trap_bar 
    bench adjustable_bench pull_up_bar dip_bars rings landmine plate rings_or_TRX medicine_ball
  ].freeze

  VALID_TRAINING_EFFECTS = %w[
    strength power endurance mobility stability speed unilateral
  ].freeze

  validates :name, :movement_pattern, presence: true
  validates :complexity_level, inclusion: { in: %w[beginner intermediate advanced] }
  validates :effectiveness_score, inclusion: { in: 1..10 }

  # JSONB array validations
  validate :validate_muscle_whitelist
  validate :validate_equipment_whitelist
  validate :validate_training_effects_whitelist

  enum :complexity_level, { beginner: 1, intermediate: 2, advanced: 3 }
  enum :exercise_type, { main: 0, accessory: 1 }

  # JSONB containment scopes (uses GIN indexes)
  scope :by_equipment, ->(equipment_list) {
    where("equipment_required ?| array[:equipment]", equipment: equipment_list)
  }
  scope :by_muscles, ->(muscle_list) {
    where("primary_muscles ?| array[:muscles]", muscles: muscle_list)
  }
  scope :by_training_effects, ->(effects_list) {
    where("training_effects ?| array[:effects]", effects: effects_list)
  }
  scope :by_complexity, ->(level) { where(complexity_level: level) }
  scope :high_effectiveness, -> { where("effectiveness_score >= ?", 7) }

  def equipment_list
    equipment_required || []
  end

  def muscle_list
    primary_muscles || []
  end

  def training_effects_list
    training_effects || []
  end

  # Smart substitution finder with main-lift prioritization
  # For main exercises: prioritize other main exercises first (main-worthy substitutes)
  # For accessory exercises: use standard movement pattern + muscle group logic
  def find_substitutes(user_equipment = nil, max_results = 10)
    base_query = Exercise.where.not(id: self.id)

    # Apply equipment filter to all candidates if provided
    if user_equipment.is_a?(Array)
      if user_equipment.empty?
        # No equipment available - only bodyweight exercises (empty equipment_required)
        base_query = base_query.where("equipment_required = '[]'::jsonb OR equipment_required IS NULL")
      else
        # Specific equipment available
        base_query = base_query.where("equipment_required ?| array[:equipment] OR equipment_required = '[]'::jsonb", equipment: user_equipment)
      end
    end

    if main?
      find_main_exercise_substitutes(base_query, max_results)
    else
      find_standard_substitutes(base_query, max_results)
    end
  end

  private

  def find_main_exercise_substitutes(base_query, max_results)
    results = []

    # 1. PRIORITY: Other main exercises in same movement pattern (e.g., front squat for back squat)
    main_same_movement = base_query.where(movement_pattern: self.movement_pattern, exercise_type: :main)
    if main_same_movement.exists?
      results += main_same_movement.order(effectiveness_score: :desc, complexity_level: :asc).limit(3)
    end

    remaining_slots = max_results - results.length
    return results if remaining_slots <= 0

    # 2. Main exercises from related patterns with muscle overlap (e.g., deadlifts for squats)
    if self.primary_muscles.any?
      main_cross_pattern = base_query.where.not(movement_pattern: self.movement_pattern)
                                   .where(exercise_type: :main)
                                   .where("primary_muscles ?| array[:muscles]", muscles: self.primary_muscles)
      if main_cross_pattern.exists?
        results += main_cross_pattern.order(effectiveness_score: :desc).limit([ remaining_slots, 2 ].min)
      end
    end

    remaining_slots = max_results - results.length
    return results if remaining_slots <= 0

    # 3. Fall back to standard logic for remaining slots
    standard_results = find_standard_substitutes(base_query.where.not(id: results.map(&:id)), remaining_slots)
    results + standard_results
  end

  def find_standard_substitutes(base_query, max_results)
    # Standard logic: same movement pattern > muscle/training effect overlap
    same_movement = base_query.where(movement_pattern: self.movement_pattern)
    cross_pattern = base_query.where.not(movement_pattern: self.movement_pattern)

    # Filter cross-pattern by muscle or training effect overlap
    if self.primary_muscles.any?
      cross_pattern = cross_pattern.where("primary_muscles ?| array[:muscles]", muscles: self.primary_muscles)
    elsif self.training_effects.any?
      cross_pattern = cross_pattern.where("training_effects ?| array[:effects]", effects: self.training_effects)
    end

    results = []

    if same_movement.exists?
      # Show most same-movement-pattern options, plus some cross-pattern
      same_movement_limit = [ max_results - 2, 3 ].max
      results += same_movement.order(:complexity_level, effectiveness_score: :desc).limit(same_movement_limit)

      remaining_slots = max_results - results.length
      if remaining_slots > 0 && cross_pattern.exists?
        results += cross_pattern.order(effectiveness_score: :desc).limit(remaining_slots)
      end
    else
      # No same movement pattern - show cross-pattern alternatives
      results = cross_pattern.order(effectiveness_score: :desc).limit(max_results)
    end

    results
  end

  def validate_muscle_whitelist
    return unless primary_muscles
    invalid_muscles = primary_muscles - VALID_MUSCLES
    errors.add(:primary_muscles, "contains invalid muscles: #{invalid_muscles.join(', ')}") if invalid_muscles.any?
  end

  def validate_equipment_whitelist
    return unless equipment_required
    invalid_equipment = equipment_required - VALID_EQUIPMENT
    errors.add(:equipment_required, "contains invalid equipment: #{invalid_equipment.join(', ')}") if invalid_equipment.any?
  end

  def validate_training_effects_whitelist
    return unless training_effects
    invalid_effects = training_effects - VALID_TRAINING_EFFECTS
    errors.add(:training_effects, "contains invalid training effects: #{invalid_effects.join(', ')}") if invalid_effects.any?
  end
end
