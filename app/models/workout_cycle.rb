class WorkoutCycle < ApplicationRecord
  belongs_to :workout_program
  has_many :workout_sessions, dependent: :destroy
  has_many :workout_exercises, through: :workout_sessions

  validates :name, :workout_program, presence: true
end
