class AddExerciseTypeToWorkoutExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_exercises, :exercise_type, :integer
  end
end
