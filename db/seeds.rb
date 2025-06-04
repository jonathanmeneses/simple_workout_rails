# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed a Default User
default_user = User.find_or_create_by!(email_address: 'user@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end
puts "Default user seeded: #{default_user.email_address}"

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
  # Determine category based on movement pattern
  category = case ex[:movement_pattern]
             when "squat", "hinge", "horizontal_push", "vertical_push", "lunge", "vertical_pull", "horizontal_pull", "carry"
               "strength"
             when "core", "core_rotation"
               "core"
             when "plyometrics" # Assuming such a movement pattern could exist or be inferred from exercise name
               "plyometrics"
             else
               "general" # Default category
             end
  # Special override for plyo exercises by name if not by movement pattern
  if ex[:name].downcase.include?("jump") || ex[:name].downcase.include?("plyo")
    category = "plyometrics"
  end

  Exercise.create!(
    name: ex[:name],
    exercise_type: ex[:type], # This is the existing integer enum type
    movement_pattern: movement_pattern_records[ex[:movement_pattern]],
    description: ex[:description],
    notes: ex[:notes],
    benefits: "Contributes to overall fitness, strength, and specific movement capabilities.", # Generic benefits
    category: category # New string category
  )
end

puts "Seeded #{Equipment.count} equipment items, #{MovementPattern.count} movement patterns, #{Exercise.count} exercises..."

# --- Create ExerciseEquipment Links ---
puts "Creating ExerciseEquipment links..."

# Helper to find equipment records (already created and stored in equipment_records hash)
barbell = equipment_records["barbell"]
dumbbell = equipment_records["dumbbell"]
kettlebell = equipment_records["kettlebell"]
pull_up_bar = equipment_records["pull_up_bar"]
bodyweight = equipment_records["bodyweight"] # Added for bodyweight exercises
rack = equipment_records["rack"]
trap_bar = equipment_records["trap_bar"]
rings_or_TRX = equipment_records["rings_or_TRX"]
landmine = equipment_records["landmine"]
bench = equipment_records["bench"]
dip_bars = equipment_records["dip_bars"]
plate = equipment_records["plate"] # Added plate


exercise_equipment_map = {
  'Back Squat' => [barbell, rack],
  'Cyclist Squat' => [dumbbell, kettlebell], # Often done with DB/KB or just bodyweight + heel wedge
  'Goblet Squat' => [kettlebell, dumbbell],
  'Kettlebell Rack Squat' => [kettlebell],
  'Zercher Squat' => [barbell, rack],
  'Assisted Knee-Over-Toe Squat' => [bodyweight], # Or a rail/support
  'Jump Squat' => [bodyweight],
  'Conventional Deadlift' => [barbell],
  'Trap-Bar Deadlift' => [trap_bar],
  'Romanian Deadlift' => [barbell, dumbbell],
  'Zercher Good Morning' => [barbell],
  'Single-Leg Romanian Deadlift' => [dumbbell, kettlebell, bodyweight],
  'Hip Thrust' => [barbell, bench],
  'Jefferson Curl' => [barbell, kettlebell], # Light weight
  'Kettlebell Swing' => [kettlebell],
  'Bench Press' => [barbell, rack, bench],
  'Incline Dumbbell Press' => [dumbbell, bench], # Assuming adjustable bench is a type of bench
  'Dip' => [dip_bars, rings_or_TRX], # Dip bars or rings
  'Push-Up' => [bodyweight],
  'Z Press' => [barbell, dumbbell], # Can be done with either
  'Bradford Press' => [barbell],
  'Single-Arm Landmine Z Press' => [landmine, barbell], # Landmine setup uses a barbell
  'Tall / Half-Kneeling Landmine Press' => [landmine, barbell],
  'Seated / Half-Kneeling Filly Press' => [dumbbell, kettlebell],
  'Scapular Push-Up' => [bodyweight],
  'Pull-Up / Chin-Up' => [pull_up_bar, rings_or_TRX],
  'Chest-Supported Row' => [dumbbell, bench], # Or specific machine
  'Bent-Over Row' => [barbell, dumbbell],
  'Pendlay Row' => [barbell],
  'TRX / Ring Row' => [rings_or_TRX],
  'Muscle-Up Row' => [rings_or_TRX], # Typically rings
  'Single-Arm Dumbbell / Meadows Row' => [dumbbell, landmine], # Meadows row uses landmine
  'Active Hang / Scap Pull-Up' => [pull_up_bar],
  'Chest-to-Bar Pull-Up' => [pull_up_bar],
  'Split Squat' => [dumbbell, barbell, bodyweight],
  'Front Foot Elevated Split Squat' => [dumbbell, barbell, bodyweight],
  'Rear Foot Elevated Split Squat (Bulgarian)' => [dumbbell, barbell, bench],
  'Front Rack Rear Foot Elevated Split Squat' => [barbell, bench],
  'Walking Lunge' => [dumbbell, barbell, bodyweight],
  'Cossack Squat' => [kettlebell, dumbbell, bodyweight],
  'Knee Over Toe Split Squat (Deep Range)' => [bodyweight, dumbbell],
  'Jump Switch Lunges' => [bodyweight],
  'Farmer\'s Carry' => [dumbbell, kettlebell, trap_bar], # Trap bar can be used for frame carry
  'Suitcase Carry' => [dumbbell, kettlebell],
  'Front Rack (Filly) Carry' => [kettlebell, dumbbell], # Usually KBs
  'Overhead Carry' => [dumbbell, kettlebell, barbell, plate],
  'Dead Bug / Hollow Hold' => [bodyweight],
  'Med Ball Rotational Slam / Toss' => [equipment_records["medicine_ball"]],
  'Strict Toes-to-Bar' => [pull_up_bar],
  'Knee Tucks in Dip Support' => [dip_bars]
}

exercise_equipment_map.each do |exercise_name, eq_records|
  exercise = Exercise.find_by(name: exercise_name)
  next unless exercise

  eq_records.each do |equipment_item|
    next unless equipment_item # Skip if an equipment name wasn't found (e.g. typo in map)
    ExerciseEquipment.find_or_create_by!(exercise: exercise, equipment: equipment_item)
  end
end

puts "Created #{ExerciseEquipment.count} ExerciseEquipment links."

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
    user: default_user, # Assign the default user
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
        exercise = Exercise.find_or_create_by!(name: exercise_data[:name]) do |ex_new|
          # This block only runs if the exercise is being CREATED
          ex_new.movement_pattern = MovementPattern.first # Default if not in EXERCISES list
          ex_new.description = exercise_data[:notes] # Basic description from notes
          ex_new.benefits = "Contributes to overall fitness and performance." # Generic benefits for new
          ex_new.category = exercise_data[:type] == "main" ? "strength" : "accessory" # Basic category for new
          # Note: ex_new.exercise_type (the integer enum) is not set here, relies on initial EXERCISES list or manual setup.
        end

        # Ensure benefits and category are set even if exercise was just found (and might have been from old seed)
        # For exercises found by name that might not have these fields from the initial EXERCISES loop
        current_category = exercise.category
        if current_category.blank?
          # Infer category based on its already associated movement_pattern if it exists
          # This is more robust if the exercise was found and already has a movement pattern.
          if exercise.movement_pattern
            mp_name = exercise.movement_pattern.name.downcase
            current_category = case mp_name
                              when "squat", "hinge", "horizontal_push", "vertical_push", "lunge", "vertical_pull", "horizontal_pull", "carry"
                                "strength"
                              when "core", "core_rotation"
                                "core"
                              else # plyo check by name, or default for others
                                exercise.name.downcase.include?("jump") || exercise.name.downcase.include?("plyo") ? "plyometrics" : "general"
                              end
          else # Fallback if no movement pattern somehow
            current_category = exercise_data[:type] == "main" ? "strength" : "accessory"
          end
        end

        exercise.update!(
          benefits: exercise.benefits.presence || "Contributes to overall fitness and performance.",
          category: current_category
        )

        # Create the workout exercise
        wo_ex = workout_session.workout_exercises.create!(
          exercise: exercise,
          # The old direct assignment of sets/reps to WorkoutExercise is removed
          # as this is now handled by WorkoutSet records.
          # If WorkoutExercise model still has :sets and :reps columns, they will be nil or as per model defaults.
          notes: exercise_data[:notes], # Assign notes from hardcoded data directly
          order_position: index + 1,
          exercise_type: exercise_data[:type] == "main" ? :main : :accessory
        )

        # --- Begin WorkoutSet Population ---
        num_sets = 0
        rep_schemes = [] # Array to hold target_reps for each set

        set_info = exercise_data[:sets]
        reps_info = exercise_data[:reps].to_s.strip # Ensure string and remove whitespace

        if set_info.is_a?(Integer)
          num_sets = set_info
          num_sets.times { rep_schemes << reps_info }
        elsif set_info.is_a?(String)
          if set_info.match?(/(\d+)\s*[x×]\s*(\S+)/i) # Format like "2x5", "3 x 8-10" (handles both 'x' and '×')
            matches = set_info.match(/(\d+)\s*[x×]\s*(\S+)/i)
            num_actual_sets = matches[1].to_i
            reps_for_regular_sets = matches[2].strip

            num_sets = num_actual_sets
            num_sets.times { rep_schemes << reps_for_regular_sets } # Default for all sets

            # If reps_info is present and different (e.g., "+ AMRAP"), it overrides the last set
            if !reps_info.empty? && reps_info != reps_for_regular_sets
              rep_schemes[-1] = reps_info if rep_schemes.any?
            end
          else
            # Try to convert string sets to integer (e.g., "3")
            parsed_sets_as_int = set_info.to_i
            if parsed_sets_as_int > 0
              num_sets = parsed_sets_as_int
              num_sets.times { rep_schemes << reps_info }
            else
              puts "      [Warning] Unparseable sets string for '#{exercise.name}' in '#{day_data[:title]}': '#{set_info}'. Defaulting to 1 set."
              num_sets = 1
              rep_schemes << reps_info
            end
          end
        else # nil or other type
          puts "      [Warning] Nil or unhandled sets type for '#{exercise.name}' in '#{day_data[:title]}': #{set_info.inspect}. Defaulting to 1 set."
          num_sets = 1
          rep_schemes << (reps_info.empty? ? "N/A" : reps_info) # Ensure reps_info is not empty if sets is nil
        end

        # If after parsing, num_sets is positive but rep_schemes is empty (should not happen with current logic but as a safeguard)
        if num_sets > 0 && rep_schemes.empty?
            num_sets.times { rep_schemes << (reps_info.empty? ? "N/A" : reps_info) }
        end

        if num_sets == 0 && !reps_info.empty?
            puts "      [Info] Zero sets explicitly defined for '#{exercise.name}' in '#{day_data[:title]}', but reps info ('#{reps_info}') exists. No sets will be created."
        end

        rep_schemes.each_with_index do |reps_for_set, i|
          wo_ex.workout_sets.create!(
            order: i + 1,
            target_reps: reps_for_set.empty? ? "N/A" : reps_for_set, # Handle empty reps_for_set
            target_weight: nil, # Placeholder
            notes: nil # Placeholder for potential future set-specific notes
          )
        end
        # --- End WorkoutSet Population ---
      end
    end
  end
end

puts "Seeded #{WorkoutProgram.count} workout programs"
puts "Seeded #{WorkoutCycle.count} workout cycles"
puts "Seeded #{WorkoutSession.count} workout sessions"
puts "Seeded #{WorkoutExercise.count} workout exercises"
puts "Seeded #{WorkoutSet.count} workout sets" # Added count for WorkoutSet
