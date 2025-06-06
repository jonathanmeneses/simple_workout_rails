# Import script for unified exercise database
# This safely imports the comprehensive exercise dataset while preserving existing workout programs

require 'json'

puts "🚀 Importing unified exercise database..."

# Load the unified JSON data
json_file = File.read(Rails.root.join('db', 'unified_exercise_database.json'))
exercises_data = JSON.parse(json_file)

puts "📊 Found #{exercises_data.length} exercises in unified database"

# Track statistics
created_count = 0
updated_count = 0
skipped_count = 0
errors = []

# Import each exercise
exercises_data.each_with_index do |exercise_data, index|
  begin
    # Find or create movement pattern
    movement_pattern = MovementPattern.find_or_create_by!(
      name: exercise_data['movement_pattern']
    )
    
    # Map complexity level from string to enum key (for Rails enum)
    complexity_mapping = {
      'beginner' => 'beginner',
      'intermediate' => 'intermediate', 
      'advanced' => 'advanced'
    }
    
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
      complexity_level: complexity_mapping[exercise_data['complexity_level']] || 'intermediate',
      effectiveness_score: exercise_data['effectiveness_score'] || 5,
      description: exercise_data['enhanced_description'],
      # Store workout contexts in notes for now (could be separate model later)
      notes: exercise_data['workout_contexts'].any? ? 
             "Used in programs: #{exercise_data['workout_contexts'].map { |ctx| ctx['program'] }.uniq.join(', ')}" : 
             nil
    }
    
    if exercise
      # Update existing exercise with enhanced attributes
      exercise.update!(exercise_attributes)
      updated_count += 1
      puts "  ✏️  Updated: #{exercise.name}" if updated_count % 10 == 0
    else
      # Create new exercise
      exercise = Exercise.create!(exercise_attributes)
      created_count += 1
      puts "  ➕ Created: #{exercise.name}" if created_count % 25 == 0
    end
    
  rescue => e
    error_msg = "Failed to import #{exercise_data['exercise_name']}: #{e.message}"
    errors << error_msg
    puts "  ❌ #{error_msg}"
    skipped_count += 1
  end
end

puts "\n📊 Import Summary:"
puts "  • Created: #{created_count} exercises"
puts "  • Updated: #{updated_count} exercises" 
puts "  • Skipped: #{skipped_count} exercises"
puts "  • Total exercises in database: #{Exercise.count}"
puts "  • Movement patterns: #{MovementPattern.count}"

if errors.any?
  puts "\n⚠️  Errors encountered:"
  errors.each { |error| puts "  - #{error}" }
else
  puts "\n✅ Import completed successfully with no errors!"
end

# Show some sample high-effectiveness exercises
puts "\n🎯 Sample high-effectiveness exercises:"
Exercise.where(effectiveness_score: 8..10)
        .order(:effectiveness_score)
        .limit(10)
        .each do |exercise|
  puts "  #{exercise.name} (#{exercise.effectiveness_score}/10) - #{exercise.movement_pattern.name}"
end

# Show exercises by movement pattern
puts "\n📋 Exercises by movement pattern:"
MovementPattern.includes(:exercises).each do |pattern|
  count = pattern.exercises.count
  if count > 0
    sample_exercises = pattern.exercises.order(:effectiveness_score).reverse_order.limit(3)
    puts "  #{pattern.name.capitalize} (#{count}): #{sample_exercises.pluck(:name).join(', ')}"
  end
end

puts "\n🎉 Unified exercise database import complete!"
puts "🔥 You now have #{Exercise.count} exercises with comprehensive attributes!"