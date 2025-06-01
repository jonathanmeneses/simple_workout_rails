class AddDescriptionAndNotesToExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :exercises, :description, :text
    add_column :exercises, :notes, :text
  end
end
