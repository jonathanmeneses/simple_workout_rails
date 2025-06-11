class ExerciseImporter
  def self.import_all
    import_equipment
    import_movement_patterns
    import_exercises_from_json
  end

  private

  def self.import_equipment
    require 'yaml'
    equipment_yaml = YAML.load_file(Rails.root.join('db', 'data', 'updated_equipments.yml'))
    equipment_list = equipment_yaml['equipment'].map { |eq| eq['name'] }

    puts "Seeding #{equipment_list.length} standardized equipment items..."
    equipment_list.each do |name|
      Equipment.find_or_create_by!(name: name)
    end
  end

  def self.import_movement_patterns
    movement_patterns = [
      "squat", "hinge", "horizontal_push", "vertical_push", "vertical_pull", 
      "horizontal_pull", "lunge", "carry", "core", "core_rotation"
    ]

    movement_patterns.each do |name|
      MovementPattern.find_or_create_by!(name: name)
    end
  end

  def self.import_exercises_from_json
    require 'json'

    puts "Loading unified exercise database..."
    json_file = File.read(Rails.root.join('db', 'data', 'unified_exercise_database.json'))
    exercises_data = JSON.parse(json_file)

    puts "📊 Found #{exercises_data.length} exercises in unified database"

    created_count = 0
    updated_count = 0
    skipped_count = 0

    exercises_data.each_with_index do |exercise_data, index|
      begin
        # Find or create movement pattern
        movement_pattern = MovementPattern.find_or_create_by!(
          name: exercise_data['movement_pattern']
        )

        # Determine exercise type based on effectiveness score and program usage
        exercise_type = if exercise_data['is_in_programs'] &&
                          exercise_data['workout_contexts'].any? { |ctx| ctx['type'] == 'main' }
                       'main'
        else
                         'accessory'
        end

        # Find existing exercise or create new one
        exercise = Exercise.find_by(name: exercise_data['exercise_name'])

        exercise_attributes = {
          name: exercise_data['exercise_name'],
          movement_pattern: movement_pattern,
          exercise_type: exercise_type,
          primary_muscles: exercise_data['primary_muscles'] || [],
          equipment_required: exercise_data['equipment_required'] || [],
          training_effects: exercise_data['training_effects'] || [],
          complexity_level: exercise_data['complexity_level'] || 'intermediate',
          effectiveness_score: exercise_data['effectiveness_score'] || 5,
          description: exercise_data['enhanced_description']
        }

        if exercise
          exercise.update!(exercise_attributes)
          updated_count += 1
        else
          Exercise.create!(exercise_attributes)
          created_count += 1
        end

        puts "  Processed #{index + 1}/#{exercises_data.length} exercises" if (index + 1) % 50 == 0

      rescue => e
        puts "  ❌ Failed to import #{exercise_data['exercise_name']}: #{e.message}"
        skipped_count += 1
      end
    end

    puts "📊 Exercise Import Summary:"
    puts "  • Created: #{created_count} exercises"
    puts "  • Updated: #{updated_count} exercises"
    puts "  • Skipped: #{skipped_count} exercises"
  end
end