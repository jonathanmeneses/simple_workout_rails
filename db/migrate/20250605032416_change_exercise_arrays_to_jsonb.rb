class ChangeExerciseArraysToJsonb < ActiveRecord::Migration[8.0]
  def up
    # Remove old text-based indexes
    remove_index :exercises, :training_effects
    
    # Convert text columns to jsonb with proper casting
    execute "ALTER TABLE exercises ALTER COLUMN primary_muscles TYPE jsonb USING COALESCE(primary_muscles::jsonb, '[]'::jsonb)"
    execute "ALTER TABLE exercises ALTER COLUMN equipment_required TYPE jsonb USING COALESCE(equipment_required::jsonb, '[]'::jsonb)"  
    execute "ALTER TABLE exercises ALTER COLUMN training_effects TYPE jsonb USING COALESCE(training_effects::jsonb, '[]'::jsonb)"
    
    # Set defaults
    change_column_default :exercises, :primary_muscles, []
    change_column_default :exercises, :equipment_required, []
    change_column_default :exercises, :training_effects, []
    
    # Add GIN indexes for containment searches
    add_index :exercises, :primary_muscles, using: :gin
    add_index :exercises, :equipment_required, using: :gin
    add_index :exercises, :training_effects, using: :gin
  end
  
  def down
    # Reverse the changes
    remove_index :exercises, :primary_muscles
    remove_index :exercises, :equipment_required  
    remove_index :exercises, :training_effects
    
    change_column :exercises, :primary_muscles, :text
    change_column :exercises, :equipment_required, :text
    change_column :exercises, :training_effects, :text
    
    add_index :exercises, :training_effects
  end
end
