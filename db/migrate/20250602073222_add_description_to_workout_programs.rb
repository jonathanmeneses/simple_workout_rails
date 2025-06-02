class AddDescriptionToWorkoutPrograms < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_programs, :description, :text
  end
end
