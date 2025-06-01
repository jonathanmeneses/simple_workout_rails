class CreateWorkoutSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_sessions do |t|
      t.string :name
      t.references :workout_cycle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
