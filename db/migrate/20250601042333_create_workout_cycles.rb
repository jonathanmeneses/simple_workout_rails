class CreateWorkoutCycles < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_cycles do |t|
      t.string :name
      t.integer :cycle_type
      t.references :workout_program, null: false, foreign_key: true

      t.timestamps
    end
  end
end
