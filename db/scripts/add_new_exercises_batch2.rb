# Add remaining 14 exercises that failed due to equipment validation
require_relative '../../config/environment'

puts "🏋️ Adding remaining 14 exercises with corrected equipment..."

# The 14 exercises that failed equipment validation
remaining_exercises = [
  {
    name: '45° Back Extension',
    description: 'An effective movement for strengthening the hamstrings, glutes and low back at the same time.',
    movement_pattern: 'hinge',
    exercise_type: 'accessory',
    primary_muscles: ['hamstrings', 'glutes', 'back'],
    equipment_required: ['back_extension_bench'],
    training_effects: ['strength'],
    complexity_level: 'beginner',
    effectiveness_score: 7
  },
  {
    name: '90° Back Extension',
    description: 'Similar to the 45° Back Extension, except this one will focus on the low back a bit more.',
    movement_pattern: 'hinge',
    exercise_type: 'accessory',
    primary_muscles: ['back', 'hamstrings'],
    equipment_required: ['back_extension_bench'],
    training_effects: ['strength', 'mobility'],
    complexity_level: 'beginner',
    effectiveness_score: 7
  },
  {
    name: 'Bicep Curl',
    description: 'An isolation exercise that targets the biceps by lifting weight through controlled arc.',
    movement_pattern: 'vertical_pull',
    exercise_type: 'accessory',
    primary_muscles: ['biceps', 'forearms'],
    equipment_required: ['dumbbells'],
    training_effects: ['strength'],
    complexity_level: 'beginner',
    effectiveness_score: 5
  },
  {
    name: 'External Rotator',
    description: 'A shoulder-strengthening exercise that engages the rotator cuff.',
    movement_pattern: 'horizontal_pull',
    exercise_type: 'accessory',
    primary_muscles: ['rear_delts'],
    equipment_required: ['resistance_bands'],
    training_effects: ['stability'],
    complexity_level: 'beginner',
    effectiveness_score: 6
  },
  {
    name: 'Facepull',
    description: 'A targeted strength movement for the upper back and shoulders.',
    movement_pattern: 'horizontal_pull',
    exercise_type: 'accessory',
    primary_muscles: ['rear_delts', 'rhomboids'],
    equipment_required: ['cable_machine'],
    training_effects: ['strength'],
    complexity_level: 'beginner',
    effectiveness_score: 7
  },
  {
    name: 'GHD Sit-Up',
    description: 'A core-strengthening exercise that engages the abs and hip flexors.',
    movement_pattern: 'core',
    exercise_type: 'accessory',
    primary_muscles: ['abs', 'core'],
    equipment_required: ['ghd'],
    training_effects: ['strength'],
    complexity_level: 'intermediate',
    effectiveness_score: 7
  },
  {
    name: 'Glute Ham Raise',
    description: 'A powerful posterior chain exercise targeting the glutes, hamstrings, and lower back.',
    movement_pattern: 'hinge',
    exercise_type: 'accessory',
    primary_muscles: ['glutes', 'hamstrings'],
    equipment_required: ['glute_ham_raise'],
    training_effects: ['strength'],
    complexity_level: 'advanced',
    effectiveness_score: 9
  },
  {
    name: 'Hamstring Curl',
    description: 'A lower-body exercise that targets the hamstrings by bending the knees against resistance.',
    movement_pattern: 'hinge',
    exercise_type: 'accessory',
    primary_muscles: ['hamstrings'],
    equipment_required: ['commercial_gym_machines'],
    training_effects: ['strength'],
    complexity_level: 'beginner',
    effectiveness_score: 6
  },
  {
    name: 'Leg Extension',
    description: 'A lower-body exercise that isolates and strengthens the quadriceps.',
    movement_pattern: 'squat',
    exercise_type: 'accessory',
    primary_muscles: ['quads'],
    equipment_required: ['commercial_gym_machines'],
    training_effects: ['strength'],
    complexity_level: 'beginner',
    effectiveness_score: 5
  },
  {
    name: 'Nordic Curl',
    description: 'A challenging hamstring exercise that strengthens muscles in lengthened position.',
    movement_pattern: 'hinge',
    exercise_type: 'accessory',
    primary_muscles: ['hamstrings'],
    equipment_required: ['nordic_bench'],
    training_effects: ['strength'],
    complexity_level: 'advanced',
    effectiveness_score: 9
  },
  {
    name: 'Pullover',
    description: 'A versatile upper-body exercise that targets the chest, lats, and core.',
    movement_pattern: 'vertical_pull',
    exercise_type: 'accessory',
    primary_muscles: ['chest', 'lats'],
    equipment_required: ['dumbbells'],
    training_effects: ['strength', 'mobility'],
    complexity_level: 'intermediate',
    effectiveness_score: 7
  },
  {
    name: 'Reverse Hyper',
    description: 'A low-back and glute-focused exercise that enhances posterior chain strength.',
    movement_pattern: 'hinge',
    exercise_type: 'accessory',
    primary_muscles: ['glutes', 'back'],
    equipment_required: ['reverse_hyper'],
    training_effects: ['strength'],
    complexity_level: 'intermediate',
    effectiveness_score: 8
  },
  {
    name: 'Standing Row',
    description: 'Great for strengthening the upper back and improving posture.',
    movement_pattern: 'horizontal_pull',
    exercise_type: 'accessory',
    primary_muscles: ['lats', 'rhomboids'],
    equipment_required: ['cable_machine'],
    training_effects: ['strength'],
    complexity_level: 'beginner',
    effectiveness_score: 7
  },
  {
    name: 'Trap 3 Raise',
    description: 'An upper-back exercise that targets the mid traps.',
    movement_pattern: 'horizontal_pull',
    exercise_type: 'accessory',
    primary_muscles: ['traps'],
    equipment_required: ['dumbbells'],
    training_effects: ['strength'],
    complexity_level: 'beginner',
    effectiveness_score: 6
  }
]

puts "=" * 70
success_count = 0

remaining_exercises.each_with_index do |ex_data, index|
  puts "#{index + 1}. #{ex_data[:name]}"
  
  # Find movement pattern
  movement_pattern = MovementPattern.find_by(name: ex_data[:movement_pattern])
  if movement_pattern.nil?
    puts "   ❌ Movement pattern '#{ex_data[:movement_pattern]}' not found"
    next
  end
  
  # Create exercise
  exercise = Exercise.new(
    name: ex_data[:name],
    description: ex_data[:description],
    movement_pattern: movement_pattern,
    exercise_type: ex_data[:exercise_type],
    primary_muscles: ex_data[:primary_muscles],
    equipment_required: ex_data[:equipment_required],
    training_effects: ex_data[:training_effects],
    complexity_level: ex_data[:complexity_level],
    effectiveness_score: ex_data[:effectiveness_score]
  )
  
  if exercise.save
    puts "   ✅ Created: #{ex_data[:movement_pattern]} | #{ex_data[:primary_muscles].join(', ')} | #{ex_data[:equipment_required].any? ? ex_data[:equipment_required].join(', ') : 'bodyweight'}"
    success_count += 1
  else
    puts "   ❌ Failed: #{exercise.errors.full_messages.join(', ')}"
  end
end

puts
puts "🎯 SUMMARY: Successfully added #{success_count}/#{remaining_exercises.length} exercises"
puts "📊 New total exercises: #{Exercise.count}"

if success_count == remaining_exercises.length
  puts "✅ ALL EXERCISES ADDED SUCCESSFULLY!"
else
  puts "⚠️  Some exercises failed - check errors above"
end