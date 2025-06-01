class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.string :name
      t.references :movement_pattern, null: false, foreign_key: true
      t.integer :exercise_type

      t.timestamps
    end
  end
end
