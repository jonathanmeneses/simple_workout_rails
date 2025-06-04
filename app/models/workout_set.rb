class WorkoutSet < ApplicationRecord
  belongs_to :workout_exercise

  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :target_reps, presence: true
end
