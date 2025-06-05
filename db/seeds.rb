# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed Equipment
EQUIPMENT_LIST = [
  "barbell", "rack", "kettlebell", "dumbbell", "heel_wedge", "bodyweight", "TRX_or_rail", "trap_bar", "bench", "adjustable_bench", "pull_up_bar", "dip_bars", "rings", "landmine", "plate", "rings_or_TRX", "medicine_ball"
]

equipment_records = {}
EQUIPMENT_LIST.each do |name|
  equipment_records[name] = Equipment.find_or_create_by!(name: name)
end

# Seed Movement Patterns
MOVEMENT_PATTERNS = [
  "squat", "hinge", "horizontal_push", "vertical_push", "vertical_pull", "horizontal_pull", "lunge", "carry", "core", "core_rotation"
]

movement_pattern_records = {}
MOVEMENT_PATTERNS.each do |name|
  movement_pattern_records[name] = MovementPattern.find_or_create_by!(name: name)
end

# Seed Exercises
EXERCISES = [
  { name: "Back Squat", type: "main", movement_pattern: "squat", description: "Classic barbell squat; core compound strength builder for quads, glutes, and hamstrings.", notes: nil },
  { name: "Cyclist Squat", type: "accessory", movement_pattern: "squat", description: "Heels-elevated squat to bias quadriceps and allow an upright torso.", notes: nil },
  { name: "Goblet Squat", type: "accessory", movement_pattern: "squat", description: "Front-loaded squat that helps manage pain and adds a core challenge.", notes: nil },
  { name: "Kettlebell Rack Squat", type: "accessory", movement_pattern: "squat", description: "Double-KB front-rack squat demanding core and scapular endurance.", notes: nil },
  { name: "Zercher Squat", type: "accessory", movement_pattern: "squat", description: "Bar cradled in elbows to light up core, upper back, and legs; great for posture.", notes: nil },
  { name: "Assisted Knee-Over-Toe Squat", type: "accessory", movement_pattern: "squat", description: "Supported deep-knee squat to strengthen quads and bullet-proof knees.", notes: nil },
  { name: "Jump Squat", type: "accessory", movement_pattern: "squat", description: "Explosive squat variation to develop lower-body power and speed.", notes: nil },
  { name: "Conventional Deadlift", type: "main", movement_pattern: "hinge", description: "Barbell pull from floor; add deficit, stiff-leg, or snatch-grip for variety.", notes: nil },
  { name: "Trap-Bar Deadlift", type: "main", movement_pattern: "hinge", description: "User-friendly deadlift shifting some load to quads with neutral grips.", notes: nil },
  { name: "Romanian Deadlift", type: "accessory", movement_pattern: "hinge", description: "Hip-hinge focusing on hamstrings and glutes with minimal lower-back stress.", notes: nil },
  { name: "Zercher Good Morning", type: "accessory", movement_pattern: "hinge", description: "Front-loaded good morning demanding core, upper-back, and posterior-chain strength.", notes: nil },
  { name: "Single-Leg Romanian Deadlift", type: "accessory", movement_pattern: "hinge", description: "Unilateral hinge to build balance, hip stability, and hamstring strength.", notes: nil },
  { name: "Hip Thrust", type: "accessory", movement_pattern: "hinge", description: "Barbell hip extension isolating glutes with minimal spinal load.", notes: nil },
  { name: "Jefferson Curl", type: "accessory", movement_pattern: "hinge", description: "Slow flexion drill to build hamstring flexibility and spinal resilience.", notes: "Use very light load." },
  { name: "Kettlebell Swing", type: "accessory", movement_pattern: "hinge", description: "Powerful hip snap for posterior-chain conditioning and speed.", notes: nil },
  { name: "Bench Press", type: "main", movement_pattern: "horizontal_push", description: "Classic upper-body strength lift targeting chest, shoulders, and triceps.", notes: nil },
  { name: "Incline Dumbbell Press", type: "accessory", movement_pattern: "horizontal_push", description: "Press on an incline to emphasize upper chest fibers.", notes: nil },
  { name: "Dip", type: "accessory", movement_pattern: "vertical_push", description: "Body-weight press; torso angle shifts emphasis between chest and triceps.", notes: nil },
  { name: "Push-Up", type: "accessory", movement_pattern: "horizontal_push", description: "Scalable body-weight press that also challenges core stability.", notes: nil },
  { name: "Z Press", type: "main", movement_pattern: "vertical_push", description: "Seated floor overhead press that forces strict form and core engagement.", notes: nil },
  { name: "Bradford Press", type: "accessory", movement_pattern: "vertical_push", description: "Continuous front-to-back press for prolonged shoulder time-under-tension.", notes: nil },
  { name: "Single-Arm Landmine Z Press", type: "accessory", movement_pattern: "vertical_push", description: "Unilateral landmine press improving core stability and shoulder control.", notes: nil },
  { name: "Tall / Half-Kneeling Landmine Press", type: "accessory", movement_pattern: "vertical_push", description: "Kneeling landmine press to build overhead strength through added stability demand.", notes: nil },
  { name: "Seated / Half-Kneeling Filly Press", type: "accessory", movement_pattern: "vertical_push", description: "Combo curl-to-press challenging scapular endurance through full range.", notes: nil },
  { name: "Scapular Push-Up", type: "accessory", movement_pattern: "horizontal_push", description: "Protraction-retraction push-up for shoulder control and scapular health.", notes: nil },
  { name: "Pull-Up / Chin-Up", type: "main", movement_pattern: "vertical_pull", description: "Vertical pull; vary grips or use towels/ropes to build comprehensive back strength.", notes: nil },
  { name: "Chest-Supported Row", type: "accessory", movement_pattern: "horizontal_pull", description: "Prone row eliminating momentum to isolate mid-back muscles.", notes: nil },
  { name: "Bent-Over Row", type: "accessory", movement_pattern: "horizontal_pull", description: "Hinge and row targeting posterior chain and upper back.", notes: nil },
  { name: "Pendlay Row", type: "accessory", movement_pattern: "horizontal_pull", description: "Pull from dead stop on floor each rep to build power and strict form.", notes: nil },
  { name: "TRX / Ring Row", type: "accessory", movement_pattern: "horizontal_pull", description: "Scalable inverted row that's gentle on shoulders and easy to progress.", notes: nil },
  { name: "Muscle-Up Row", type: "accessory", movement_pattern: "horizontal_pull", description: "False-grip rowing drill progressing athletes toward strict muscle-ups.", notes: nil },
  { name: "Single-Arm Dumbbell / Meadows Row", type: "accessory", movement_pattern: "horizontal_pull", description: "Unilateral row variations adding rotation and grip variety for back development.", notes: nil },
  { name: "Active Hang / Scap Pull-Up", type: "accessory", movement_pattern: "vertical_pull", description: "Shoulder-health drill building grip endurance and overhead mobility via scapular motion.", notes: nil },
  { name: "Chest-to-Bar Pull-Up", type: "accessory", movement_pattern: "vertical_pull", description: "Explosive pull-up variant finishing with bar contact at chest to build upper-body power.", notes: nil },
  { name: "Split Squat", type: "main", movement_pattern: "lunge", description: "Stationary split-stance squat that builds unilateral leg strength and balance.", notes: nil },
  { name: "Front Foot Elevated Split Squat", type: "accessory", movement_pattern: "lunge", description: "Elevating the front foot deepens range of motion and stretches hip flexors.", notes: nil },
  { name: "Rear Foot Elevated Split Squat (Bulgarian)", type: "accessory", movement_pattern: "lunge", description: "Rear foot on bench to drive quad or glute emphasis while challenging balance and intensity.", notes: nil },
  { name: "Front Rack Rear Foot Elevated Split Squat", type: "accessory", movement_pattern: "lunge", description: "Barbell front-racked Bulgarian split squat that hammers posture, core, and leg strength together.", notes: nil },
  { name: "Walking Lunge", type: "accessory", movement_pattern: "lunge", description: "Alternating forward lunges add dynamic movement, coordination, and balance demands.", notes: nil },
  { name: "Cossack Squat", type: "accessory", movement_pattern: "lunge", description: "Side-to-side squat that opens hips and trains lateral single-leg strength.", notes: nil },
  { name: "Knee Over Toe Split Squat (Deep Range)", type: "accessory", movement_pattern: "lunge", description: "Deep split squat driving the knee far forward to improve quad strength and hip flexor mobility.", notes: nil },
  { name: "Jump Switch Lunges", type: "accessory", movement_pattern: "lunge", description: "Plyometric split-stance jumps that train explosiveness, balance, and coordination.", notes: nil },
  { name: "Farmer's Carry", type: "main", movement_pattern: "carry", description: "Walk with heavy loads at the sides to build full-body strength and grip endurance.", notes: nil },
  { name: "Suitcase Carry", type: "accessory", movement_pattern: "carry", description: "Single-sided carry forcing anti-rotation core stability and strong grip.", notes: nil },
  { name: "Front Rack (Filly) Carry", type: "accessory", movement_pattern: "carry", description: "Double-KB front-rack carry challenging core, scapular endurance, and posture.", notes: nil },
  { name: "Overhead Carry", type: "accessory", movement_pattern: "carry", description: "Walk with load locked out overhead to tax shoulder stability and midline control.", notes: nil },
  { name: "Dead Bug / Hollow Hold", type: "accessory", movement_pattern: "core", description: "Ground-based core isometrics that bullet-proof the trunk and teach spinal control.", notes: nil },
  { name: "Med Ball Rotational Slam / Toss", type: "accessory", movement_pattern: "core_rotation", description: "Explosive rotational throws or slams to develop torso power and athletic expression.", notes: nil },
  { name: "Strict Toes-to-Bar", type: "accessory", movement_pattern: "core", description: "Controlled raise of feet to bar building core strength, mobility, and lat engagement.", notes: nil },
  { name: "Knee Tucks in Dip Support", type: "accessory", movement_pattern: "core", description: "Support on dip bars while tucking knees to chest to train hip flexors and deep core.", notes: nil }
]

EXERCISES.each do |ex|
  Exercise.create!(
    name: ex[:name],
    exercise_type: ex[:type],
    movement_pattern: movement_pattern_records[ex[:movement_pattern]],
    description: ex[:description],
    notes: ex[:notes],
    complexity_level: ex[:type] == "main" ? :intermediate : :beginner,
    effectiveness_score: ex[:type] == "main" ? 8 : 6
  )
end

puts "Seeded #{Equipment.count} equipment items, #{MovementPattern.count} movement patterns, #{Exercise.count} exercises..."

# Clear existing workout program data only (keep exercises, equipment, movement patterns)
WorkoutExercise.destroy_all
WorkoutSession.destroy_all
WorkoutCycle.destroy_all
WorkoutProgram.destroy_all

puts "Cleared existing workout program data..."

# Load demo programs from hardcoded data (no more YAML dependency)
require_relative 'hardcoded_program_data'
demo_data = HARDCODED_PROGRAM_DATA
puts "Demo data loaded from hardcoded source"

demo_data.each do |program_id, program_data|
  next unless program_data.is_a?(Hash) && program_data[:name]
  
  puts "Creating program: #{program_data[:name]}"
  
  # Create the workout program
  workout_program = WorkoutProgram.create!(
    name: program_data[:name],
    description: program_data[:description],
    program_type: program_data[:name].include?("3-Day") ? :full_body_3_day : :upper_lower_4_day
  )

  # Create cycles for this program
  program_data[:cycles]&.each do |cycle_data|
    puts "  Creating cycle: #{cycle_data[:name]}"
    
    workout_cycle = workout_program.workout_cycles.create!(
      name: cycle_data[:name],
      description: cycle_data[:description]
    )

    # Create sessions for this cycle
    cycle_data[:days]&.each do |day_data|
      puts "    Creating session: #{day_data[:title]}"
      
      workout_session = workout_cycle.workout_sessions.create!(
        name: day_data[:title]
      )

      # Create exercises for this session
      day_data[:exercises]&.each_with_index do |exercise_data, index|
        # Find or create the exercise
        exercise = Exercise.find_or_create_by!(name: exercise_data[:name]) do |ex|
          # Use a default movement pattern if not found in existing data
          ex.movement_pattern = MovementPattern.first
          ex.description = exercise_data[:notes]
        end

        # Create the workout exercise
        # Store sets/reps in notes if they're strings, otherwise use the integer columns
        sets_value = exercise_data[:sets].is_a?(Integer) ? exercise_data[:sets] : nil
        reps_value = exercise_data[:reps].is_a?(Integer) ? exercise_data[:reps] : nil
        
        # Build comprehensive notes that include sets/reps info plus original notes
        notes_parts = []
        notes_parts << exercise_data[:sets] if exercise_data[:sets].present?
        notes_parts << exercise_data[:reps] if exercise_data[:reps].present?
        notes_parts << exercise_data[:notes] if exercise_data[:notes].present?
        
        workout_session.workout_exercises.create!(
          exercise: exercise,
          sets: sets_value,
          reps: reps_value,
          notes: notes_parts.join(" - "),
          order_position: index + 1,
          exercise_type: exercise_data[:type] == "main" ? :main : :accessory
        )
      end
    end
  end
end

puts "Seeded #{WorkoutProgram.count} workout programs"
puts "Seeded #{WorkoutCycle.count} workout cycles"
puts "Seeded #{WorkoutSession.count} workout sessions"
puts "Seeded #{WorkoutExercise.count} workout exercises"
