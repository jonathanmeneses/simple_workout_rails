# Exercise Substitution Seeding Script
# This adds comprehensive attributes and substitutions to existing exercises

puts "🔥 Adding comprehensive exercise data and substitutions..."

# First, let's enhance some core exercises with attributes
squat_pattern = MovementPattern.find_by(name: 'squat')
hinge_pattern = MovementPattern.find_by(name: 'hinge')
h_push_pattern = MovementPattern.find_by(name: 'horizontal_push')
v_push_pattern = MovementPattern.find_by(name: 'vertical_push')
v_pull_pattern = MovementPattern.find_by(name: 'vertical_pull')
h_pull_pattern = MovementPattern.find_by(name: 'horizontal_pull')

# Update Back Squat with comprehensive data
back_squat = Exercise.find_by(name: 'Back Squat')
if back_squat
  back_squat.update!(
    primary_muscles: [ 'quads', 'glutes', 'core' ],
    equipment_required: [ 'barbell', 'squat_rack' ],
    complexity_level: 2, # intermediate
    effectiveness_score: 9,
    instructions: 'Set up in squat rack, bar on upper traps. Descend by sitting back, knees track over toes. Drive through heels to stand.'
  )
  puts "✅ Enhanced Back Squat"
end

# Update Deadlift
deadlift = Exercise.find_by(name: 'Deadlift')
if deadlift
  deadlift.update!(
    primary_muscles: [ 'hamstrings', 'glutes', 'lats', 'traps' ],
    equipment_required: [ 'barbell' ],
    complexity_level: 3, # advanced
    effectiveness_score: 10,
    instructions: 'Hip hinge movement. Grip bar, chest up, drive hips forward to stand tall.'
  )
  puts "✅ Enhanced Deadlift"
end

# Update Bench Press
bench_press = Exercise.find_by(name: 'Bench Press')
if bench_press
  bench_press.update!(
    primary_muscles: [ 'chest', 'triceps', 'front_delts' ],
    equipment_required: [ 'barbell', 'bench' ],
    complexity_level: 2,
    effectiveness_score: 9,
    instructions: 'Lie on bench, grip bar slightly wider than shoulders. Lower to chest, press back up.'
  )
  puts "✅ Enhanced Bench Press"
end

# Create alternative exercises and substitutions
puts "\n🔄 Creating exercise alternatives and substitutions..."

# Create Goblet Squat as Back Squat alternative
goblet_squat = Exercise.find_or_create_by(
  name: 'Goblet Squat',
  movement_pattern: squat_pattern
) do |e|
  e.primary_muscles = [ 'quads', 'glutes' ]
  e.equipment_required = [ 'dumbbell' ]
  e.complexity_level = 1 # beginner
  e.effectiveness_score = 7
  e.description = 'Beginner-friendly squat variation using dumbbell'
  e.instructions = 'Hold dumbbell at chest. Squat down keeping chest up, drive through heels to stand.'
end

# Create substitution relationship
if back_squat && goblet_squat
  ExerciseSubstitution.find_or_create_by(
    original_exercise: back_squat,
    alternative_exercise: goblet_squat
  ) do |sub|
    sub.substitution_reason = 'Equipment: dumbbell vs barbell'
    sub.compatibility_score = 8
  end
  puts "✅ Created Back Squat → Goblet Squat substitution"
end

# Create Dumbbell Bench Press as Bench Press alternative
db_bench = Exercise.find_or_create_by(
  name: 'Dumbbell Bench Press',
  movement_pattern: h_push_pattern
) do |e|
  e.primary_muscles = [ 'chest', 'triceps', 'front_delts' ]
  e.equipment_required = [ 'dumbbells', 'bench' ]
  e.complexity_level = 2
  e.effectiveness_score = 8
  e.description = 'Dumbbell variation of bench press'
  e.instructions = 'Lie on bench with dumbbells. Press up and together, lower with control.'
end

if bench_press && db_bench
  ExerciseSubstitution.find_or_create_by(
    original_exercise: bench_press,
    alternative_exercise: db_bench
  ) do |sub|
    sub.substitution_reason = 'Equipment: dumbbells vs barbell'
    sub.compatibility_score = 9
  end
  puts "✅ Created Bench Press → Dumbbell Bench Press substitution"
end

# Create Push-ups as Bench Press alternative
pushup = Exercise.find_or_create_by(
  name: 'Push-up',
  movement_pattern: h_push_pattern
) do |e|
  e.primary_muscles = [ 'chest', 'triceps', 'core' ]
  e.equipment_required = [ 'bodyweight' ]
  e.complexity_level = 1
  e.effectiveness_score = 7
  e.description = 'Bodyweight horizontal push exercise'
  e.instructions = 'Plank position, lower chest to ground, push back up. Keep core tight.'
end

if bench_press && pushup
  ExerciseSubstitution.find_or_create_by(
    original_exercise: bench_press,
    alternative_exercise: pushup
  ) do |sub|
    sub.substitution_reason = 'Equipment: bodyweight vs barbell'
    sub.compatibility_score = 6
  end
  puts "✅ Created Bench Press → Push-up substitution"
end

# Create Trap Bar Deadlift as Deadlift alternative
trap_bar_dl = Exercise.find_or_create_by(
  name: 'Trap Bar Deadlift',
  movement_pattern: hinge_pattern
) do |e|
  e.primary_muscles = [ 'quads', 'glutes', 'hamstrings' ]
  e.equipment_required = [ 'trap_bar' ]
  e.complexity_level = 2
  e.effectiveness_score = 9
  e.description = 'Easier deadlift variation with neutral grip'
  e.instructions = 'Stand inside trap bar, grip handles, drive hips forward to stand.'
end

if deadlift && trap_bar_dl
  ExerciseSubstitution.find_or_create_by(
    original_exercise: deadlift,
    alternative_exercise: trap_bar_dl
  ) do |sub|
    sub.substitution_reason = 'Equipment: trap bar vs barbell - easier form'
    sub.compatibility_score = 9
  end
  puts "✅ Created Deadlift → Trap Bar Deadlift substitution"
end

# Create Romanian Deadlift as Deadlift alternative
rdl = Exercise.find_or_create_by(
  name: 'Romanian Deadlift (RDL)',
  movement_pattern: hinge_pattern
) do |e|
  e.primary_muscles = [ 'hamstrings', 'glutes' ]
  e.equipment_required = [ 'barbell' ]
  e.complexity_level = 2
  e.effectiveness_score = 8
  e.description = 'Hip hinge focused on hamstring flexibility'
  e.instructions = 'Start standing, push hips back while lowering bar. Feel stretch in hamstrings.'
end

if deadlift && rdl
  ExerciseSubstitution.find_or_create_by(
    original_exercise: deadlift,
    alternative_exercise: rdl
  ) do |sub|
    sub.substitution_reason = 'Variation: more hamstring focus, easier starting position'
    sub.compatibility_score = 8
  end
  puts "✅ Created Deadlift → Romanian Deadlift substitution"
end

puts "\n📊 Exercise substitution summary:"
puts "Total exercises: #{Exercise.count}"
puts "Total substitutions: #{ExerciseSubstitution.count}"
puts "Exercises with alternatives: #{Exercise.joins(:exercise_substitutions).distinct.count}"

puts "\n🎯 Sample substitution chains:"
Exercise.joins(:exercise_substitutions).includes(:alternatives).each do |exercise|
  puts "#{exercise.name} → #{exercise.alternatives.pluck(:name).join(', ')}"
end

puts "\n✅ Exercise substitution seeding complete!"
