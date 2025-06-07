class Exercise < ApplicationRecord
  belongs_to :movement_pattern

  # Self-referential substitution relationships
  has_many :exercise_substitutions, foreign_key: 'original_exercise_id', dependent: :destroy
  has_many :alternatives, through: :exercise_substitutions, source: :alternative_exercise
  
  has_many :reverse_exercise_substitutions, class_name: 'ExerciseSubstitution', 
           foreign_key: 'alternative_exercise_id', dependent: :destroy
  has_many :original_exercises, through: :reverse_exercise_substitutions, source: :original_exercise
  
  # Validation whitelists for JSONB arrays
  VALID_MUSCLES = %w[
    quads glutes hamstrings calves chest back lats traps rhomboids
    front_delts side_delts rear_delts triceps biceps forearms core abs obliques
  ].freeze
  
  VALID_EQUIPMENT = %w[
    barbell dumbbells kettlebell bodyweight bench squat_rack pull_up_bar
    resistance_bands medicine_ball cable_machine trap_bar safety_bar
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
  scope :high_effectiveness, -> { where('effectiveness_score >= ?', 7) }
  
  def equipment_list
    equipment_required || []
  end
  
  def muscle_list  
    primary_muscles || []
  end
  
  def training_effects_list
    training_effects || []
  end
  
  # Delegate substitution logic to service object
  def find_substitutes(user_equipment = nil, max_results = 5)
    ExerciseSubstitutionService.call(self, user_equipment: user_equipment, max_results: max_results)
  end
  
  private
  
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
