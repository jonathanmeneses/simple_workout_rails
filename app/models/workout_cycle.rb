class WorkoutCycle < ApplicationRecord
  belongs_to :workout_program
  validates :name, :workout_program, presence: true
end
