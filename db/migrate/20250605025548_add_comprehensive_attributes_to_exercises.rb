class AddComprehensiveAttributesToExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :exercises, :primary_muscles, :text, comment: "JSON array of primary muscle groups"
    add_column :exercises, :equipment_required, :text, comment: "JSON array of required equipment"
    add_column :exercises, :complexity_level, :integer, default: 1, comment: "1=beginner, 2=intermediate, 3=advanced"
    add_column :exercises, :effectiveness_score, :integer, default: 5, comment: "1-10 effectiveness rating"
    # Skip benefits - already exists as notes
    # Skip description - already exists
    add_column :exercises, :instructions, :text

    add_index :exercises, :complexity_level
    add_index :exercises, :effectiveness_score
  end
end
