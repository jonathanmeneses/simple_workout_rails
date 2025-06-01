class WorkoutExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise
end
