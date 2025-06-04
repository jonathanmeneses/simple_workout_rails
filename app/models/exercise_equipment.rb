class ExerciseEquipment < ApplicationRecord
  belongs_to :exercise
  belongs_to :equipment

  validates :exercise, presence: true
  validates :equipment, presence: true
  validates :exercise_id, uniqueness: { scope: :equipment_id, message: "already has this equipment listed" }
end
