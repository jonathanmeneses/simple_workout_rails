class AddDescriptionToWorkoutCycles < ActiveRecord::Migration[8.0]
  def change
    add_column :workout_cycles, :description, :text
  end
end
