class CreateMovementPatterns < ActiveRecord::Migration[8.0]
  def change
    create_table :movement_patterns do |t|
      t.string :name

      t.timestamps
    end
  end
end
