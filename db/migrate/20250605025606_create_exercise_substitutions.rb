class CreateExerciseSubstitutions < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_substitutions do |t|
      t.references :original_exercise, null: false, foreign_key: { to_table: :exercises }
      t.references :alternative_exercise, null: false, foreign_key: { to_table: :exercises }
      t.string :substitution_reason
      t.integer :compatibility_score, default: 5, comment: "1-10 how good a substitute this is"

      t.timestamps
    end
    
    add_index :exercise_substitutions, [:original_exercise_id, :alternative_exercise_id], name: 'index_exercise_subs_on_original_and_alternative'
    add_index :exercise_substitutions, :compatibility_score
  end
end
