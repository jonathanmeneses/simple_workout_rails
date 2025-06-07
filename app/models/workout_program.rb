class WorkoutProgram < ApplicationRecord
  has_many :workout_cycles, dependent: :destroy
  has_many :workout_sessions, through: :workout_cycles

  validates :name, presence: true

  enum :program_type, { full_body_3_day: 0, upper_lower_4_day: 1 }
end
