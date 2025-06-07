# Add attributes to core exercises for testing substitution system
require_relative '../config/environment'

puts "🔥 Adding exercise attributes for substitution testing..."

exercises = [
  { name: 'Back Squat', muscles: [ 'quads', 'glutes' ], equipment: [ 'barbell', 'squat_rack' ], effects: [ 'strength' ] },
  { name: 'Goblet Squat', muscles: [ 'quads', 'glutes' ], equipment: [ 'dumbbells' ], effects: [ 'strength' ] },
  { name: 'Bodyweight Squat', muscles: [ 'quads', 'glutes' ], equipment: [ 'bodyweight' ], effects: [ 'endurance' ] },
  { name: 'Bench Press', muscles: [ 'chest', 'triceps', 'front_delts' ], equipment: [ 'barbell', 'bench' ], effects: [ 'strength' ] },
  { name: 'Push-up', muscles: [ 'chest', 'triceps', 'core' ], equipment: [ 'bodyweight' ], effects: [ 'endurance' ] },
  { name: 'Deadlift', muscles: [ 'hamstrings', 'glutes', 'back' ], equipment: [ 'barbell' ], effects: [ 'strength' ] },
  { name: 'Romanian Deadlift (RDL)', muscles: [ 'hamstrings', 'glutes' ], equipment: [ 'barbell' ], effects: [ 'strength', 'mobility' ] },
  { name: 'Overhead Press (OHP)', muscles: [ 'front_delts', 'triceps', 'core' ], equipment: [ 'barbell' ], effects: [ 'strength' ] },
  { name: 'Chin-ups', muscles: [ 'lats', 'biceps' ], equipment: [ 'pull_up_bar' ], effects: [ 'strength' ] },
  { name: 'Ring Row', muscles: [ 'lats', 'rhomboids' ], equipment: [ 'bodyweight' ], effects: [ 'strength' ] }
]

updated_count = 0
exercises.each do |ex_data|
  exercise = Exercise.find_by(name: ex_data[:name])
  if exercise
    # Skip validations for now to populate test data
    exercise.update_columns(
      primary_muscles: ex_data[:muscles],
      equipment_required: ex_data[:equipment],
      training_effects: ex_data[:effects],
      effectiveness_score: ex_data[:effects].include?('strength') ? 9 : 7
    )
    puts "✅ Updated #{exercise.name}"
    updated_count += 1
  else
    puts "❌ Could not find #{ex_data[:name]}"
  end
end

puts "\n📊 Testing substitution logic:"
puts "Updated #{updated_count} exercises with attributes"

# Test Back Squat substitutions
back_squat = Exercise.find_by(name: 'Back Squat')
if back_squat
  puts "\n🔍 Back Squat alternatives with dumbbells/bodyweight:"
  subs = back_squat.find_substitutes([ 'dumbbells', 'bodyweight' ], 5)
  subs.each do |sub|
    pattern_match = sub.movement_pattern == back_squat.movement_pattern ? "✅" : "⚠️"
    puts "  #{pattern_match} #{sub.name} (#{sub.equipment_required.join(', ')})"
  end
end

# Test Bench Press substitutions
bench_press = Exercise.find_by(name: 'Bench Press')
if bench_press
  puts "\n🔍 Bench Press alternatives with bodyweight only:"
  subs = bench_press.find_substitutes([ 'bodyweight' ], 5)
  subs.each do |sub|
    pattern_match = sub.movement_pattern == bench_press.movement_pattern ? "✅" : "⚠️"
    puts "  #{pattern_match} #{sub.name} (#{sub.equipment_required.join(', ')})"
  end
end

puts "\n✅ Exercise attribute population complete!"
puts "You can now test the substitution system in the UI at http://localhost:3001/programs"
