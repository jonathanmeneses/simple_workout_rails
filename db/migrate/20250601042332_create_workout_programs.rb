class CreateWorkoutPrograms < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_programs do |t|
      t.string :name
      t.integer :program_type

      t.timestamps
    end
  end
end
