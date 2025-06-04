class AddDetailsToExercises < ActiveRecord::Migration[8.0]
  def change
    # The 'description' column already exists from migration 20250601045828.
    # add_column :exercises, :description, :text
    add_column :exercises, :benefits, :text
    # Renaming new 'exercise_type' to 'category' to avoid conflict with existing integer 'exercise_type'
    add_column :exercises, :category, :string
  end
end
