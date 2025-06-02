class WorkoutExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise

  validates :workout_session, :exercise, presence: true
  validates :order_position, presence: true, numericality: { greater_than: 0 }

  enum :exercise_type, { main: 0, accessory: 1 }
end
