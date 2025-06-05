class ExerciseSubstitution < ApplicationRecord
  belongs_to :original_exercise, class_name: 'Exercise'
  belongs_to :alternative_exercise, class_name: 'Exercise'
  
  validates :compatibility_score, inclusion: { in: 1..10 }
  validates :original_exercise_id, uniqueness: { scope: :alternative_exercise_id }
  
  validate :exercises_cannot_be_same
  
  scope :high_compatibility, -> { where('compatibility_score >= ?', 7) }
  scope :by_equipment, ->(equipment_list) {
    joins(:alternative_exercise)
    .where("JSON_OVERLAPS(exercises.equipment_required, ?)", equipment_list.to_json)
  }
  
  private
  
  def exercises_cannot_be_same
    errors.add(:alternative_exercise, "cannot be the same as original exercise") if original_exercise_id == alternative_exercise_id
  end
end
