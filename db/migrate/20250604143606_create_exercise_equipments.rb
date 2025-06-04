class CreateExerciseEquipments < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_equipments do |t|
      t.references :exercise, null: false, foreign_key: true
      t.references :equipment, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
    add_index :exercise_equipments, [:exercise_id, :equipment_id], unique: true
  end
end
