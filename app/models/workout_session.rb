class WorkoutSession < ApplicationRecord
  belongs_to :workout_cycle
  has_many :workout_exercises, dependent: :destroy
  has_many :exercises, through: :workout_exercises

  validates :name, presence: true
end
