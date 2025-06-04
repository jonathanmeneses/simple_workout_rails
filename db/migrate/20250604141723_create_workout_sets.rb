class CreateWorkoutSets < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_sets do |t|
      t.references :workout_exercise, null: false, foreign_key: true
      t.integer :order, null: false
      t.string :target_reps, null: false
      t.string :target_weight
      t.text :notes

      t.timestamps
    end
  end
end
