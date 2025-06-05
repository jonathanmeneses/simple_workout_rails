class AddTrainingEffectToExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :exercises, :training_effects, :text, comment: "JSON array: strength, power, endurance, mobility, stability, speed, unilateral"
    add_index :exercises, :training_effects
  end
end
