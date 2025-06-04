class WorkoutExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise

  validates :workout_session, :exercise, presence: true
  validates :order_position, presence: true, numericality: { greater_than: 0 }

  has_many :workout_sets, dependent: :destroy, inverse_of: :workout_exercise
  accepts_nested_attributes_for :workout_sets, allow_destroy: true

  enum :exercise_type, { main: 0, accessory: 1 }
end
