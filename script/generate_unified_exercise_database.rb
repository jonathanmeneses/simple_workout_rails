#!/usr/bin/env ruby

require 'json'
require 'pathname'

# Base directory of the Rails app
base_dir = Pathname.new(__FILE__).dirname.parent

# Load JSON data
json_file = base_dir.join('db', 'complete_exercise_database_200.json')
exercises_data = JSON.parse(File.read(json_file))

# Load hardcoded program data
load base_dir.join('db', 'hardcoded_program_data.rb')
program_data = HARDCODED_PROGRAM_DATA

# Enhanced descriptions from seeds.rb (extracted manually from the file)
ENHANCED_DESCRIPTIONS = {
  "Back Squat" => "Classic barbell squat; core compound strength builder for quads, glutes, and hamstrings.",
  "Cyclist Squat" => "Heels-elevated squat to bias quadriceps and allow an upright torso.",
  "Goblet Squat" => "Front-loaded squat that helps manage pain and adds a core challenge.",
  "Kettlebell Rack Squat" => "Double-KB front-rack squat demanding core and scapular endurance.",
  "Zercher Squat" => "Bar cradled in elbows to light up core, upper back, and legs; great for posture.",
  "Assisted Knee-Over-Toe Squat" => "Supported deep-knee squat to strengthen quads and bullet-proof knees.",
  "Jump Squat" => "Explosive squat variation to develop lower-body power and speed.",
  "Conventional Deadlift" => "Barbell pull from floor; add deficit, stiff-leg, or snatch-grip for variety.",
  "Trap-Bar Deadlift" => "User-friendly deadlift shifting some load to quads with neutral grips.",
  "Romanian Deadlift" => "Hip-hinge focusing on hamstrings and glutes with minimal lower-back stress.",
  "Zercher Good Morning" => "Front-loaded good morning demanding core, upper-back, and posterior-chain strength.",
  "Single-Leg Romanian Deadlift" => "Unilateral hinge to build balance, hip stability, and hamstring strength.",
  "Hip Thrust" => "Barbell hip extension isolating glutes with minimal spinal load.",
  "Jefferson Curl" => "Slow flexion drill to build hamstring flexibility and spinal resilience.",
  "Kettlebell Swing" => "Powerful hip snap for posterior-chain conditioning and speed.",
  "Bench Press" => "Classic upper-body strength lift targeting chest, shoulders, and triceps.",
  "Incline Dumbbell Press" => "Press on an incline to emphasize upper chest fibers.",
  "Dip" => "Body-weight press; torso angle shifts emphasis between chest and triceps.",
  "Push-Up" => "Scalable body-weight press that also challenges core stability.",
  "Z Press" => "Seated floor overhead press that forces strict form and core engagement.",
  "Bradford Press" => "Continuous front-to-back press for prolonged shoulder time-under-tension.",
  "Single-Arm Landmine Z Press" => "Unilateral landmine press improving core stability and shoulder control.",
  "Tall / Half-Kneeling Landmine Press" => "Kneeling landmine press to build overhead strength through added stability demand.",
  "Seated / Half-Kneeling Filly Press" => "Combo curl-to-press challenging scapular endurance through full range.",
  "Scapular Push-Up" => "Protraction-retraction push-up for shoulder control and scapular health.",
  "Pull-Up / Chin-Up" => "Vertical pull; vary grips or use towels/ropes to build comprehensive back strength.",
  "Chest-Supported Row" => "Prone row eliminating momentum to isolate mid-back muscles.",
  "Bent-Over Row" => "Hinge and row targeting posterior chain and upper back.",
  "Pendlay Row" => "Pull from dead stop on floor each rep to build power and strict form.",
  "TRX / Ring Row" => "Scalable inverted row that's gentle on shoulders and easy to progress.",
  "Muscle-Up Row" => "False-grip rowing drill progressing athletes toward strict muscle-ups.",
  "Single-Arm Dumbbell / Meadows Row" => "Unilateral row variations adding rotation and grip variety for back development.",
  "Active Hang / Scap Pull-Up" => "Shoulder-health drill building grip endurance and overhead mobility via scapular motion.",
  "Chest-to-Bar Pull-Up" => "Explosive pull-up variant finishing with bar contact at chest to build upper-body power.",
  "Split Squat" => "Stationary split-stance squat that builds unilateral leg strength and balance.",
  "Front Foot Elevated Split Squat" => "Elevating the front foot deepens range of motion and stretches hip flexors.",
  "Rear Foot Elevated Split Squat (Bulgarian)" => "Rear foot on bench to drive quad or glute emphasis while challenging balance and intensity.",
  "Front Rack Rear Foot Elevated Split Squat" => "Barbell front-racked Bulgarian split squat that hammers posture, core, and leg strength together.",
  "Walking Lunge" => "Alternating forward lunges add dynamic movement, coordination, and balance demands.",
  "Cossack Squat" => "Side-to-side squat that opens hips and trains lateral single-leg strength.",
  "Knee Over Toe Split Squat (Deep Range)" => "Deep split squat driving the knee far forward to improve quad strength and hip flexor mobility.",
  "Jump Switch Lunges" => "Plyometric split-stance jumps that train explosiveness, balance, and coordination.",
  "Farmer's Carry" => "Walk with heavy loads at the sides to build full-body strength and grip endurance.",
  "Suitcase Carry" => "Single-sided carry forcing anti-rotation core stability and strong grip.",
  "Front Rack (Filly) Carry" => "Double-KB front-rack carry challenging core, scapular endurance, and posture.",
  "Overhead Carry" => "Walk with load locked out overhead to tax shoulder stability and midline control.",
  "Dead Bug / Hollow Hold" => "Ground-based core isometrics that bullet-proof the trunk and teach spinal control.",
  "Med Ball Rotational Slam / Toss" => "Explosive rotational throws or slams to develop torso power and athletic expression.",
  "Strict Toes-to-Bar" => "Controlled raise of feet to bar building core strength, mobility, and lat engagement.",
  "Knee Tucks in Dip Support" => "Support on dip bars while tucking knees to chest to train hip flexors and deep core."
}

# Function to generate enhanced descriptions for exercises not in the seeds file
def generate_enhanced_description(exercise_name, movement_pattern, primary_muscles)
  movement_descriptions = {
    "squat" => "Fundamental squatting movement that builds lower body strength",
    "hinge" => "Hip-dominant movement pattern targeting the posterior chain",
    "horizontal_push" => "Pushing movement in the horizontal plane for upper body strength",
    "vertical_push" => "Overhead pressing movement for shoulder and tricep development",
    "horizontal_pull" => "Rowing movement to strengthen the back and rear delts",
    "vertical_pull" => "Pulling movement to develop lat and bicep strength",
    "lunge" => "Unilateral leg movement that challenges balance and builds single-leg strength",
    "carry" => "Loaded carry that builds core stability and full-body strength",
    "core" => "Core stability exercise for trunk strength and spinal health",
    "core_rotation" => "Rotational core movement for athletic power and stability"
  }
  
  primary_muscle_context = case primary_muscles&.first
  when "quads" then "targeting the quadriceps"
  when "glutes" then "focusing on glute activation"
  when "hamstrings" then "emphasizing hamstring development"
  when "chest" then "building chest strength"
  when "back", "lats" then "developing back strength"
  when "front_delts" then "targeting the shoulders"
  when "core", "abs" then "strengthening the core"
  when "triceps" then "building tricep strength"
  when "biceps" then "developing bicep strength"
  else "building functional strength"
  end
  
  base_description = movement_descriptions[movement_pattern] || "Functional exercise"
  "#{base_description} #{primary_muscle_context}. A #{exercise_name.downcase} variation for comprehensive training."
end

# Function to find workout contexts for an exercise across all programs
def find_workout_contexts(exercise_name, program_data)
  contexts = []
  
  program_data.each do |program_id, program_info|
    next unless program_info.is_a?(Hash) && program_info[:cycles]
    
    program_info[:cycles].each do |cycle|
      cycle[:days]&.each do |day|
        day[:exercises]&.each do |exercise|
          # Handle name variations
          if exercise_names_match?(exercise[:name], exercise_name)
            contexts << {
              type: exercise[:type],
              sets: exercise[:sets],
              reps: exercise[:reps],
              notes: exercise[:notes],
              program: program_info[:name],
              cycle: cycle[:name],
              session: day[:title]
            }
          end
        end
      end
    end
  end
  
  contexts
end

# Function to handle exercise name variations
def exercise_names_match?(name1, name2)
  # Normalize names for comparison
  normalize = ->(name) { name.downcase.gsub(/[^\w\s]/, '').strip }
  
  norm1 = normalize.call(name1)
  norm2 = normalize.call(name2)
  
  # Direct match
  return true if norm1 == norm2
  
  # Handle common variations
  variations = {
    "deadlift" => ["conventional deadlift", "deadlift"],
    "conventional deadlift" => ["deadlift", "conventional deadlift"],
    "chin-ups" => ["pull-up / chin-up", "chin-up", "chin ups"],
    "pull-up / chin-up" => ["chin-ups", "pull-up", "chin-up"],
    "overhead press (ohp)" => ["overhead press", "ohp"],
    "overhead press" => ["overhead press (ohp)", "ohp"],
    "farmer carry" => ["farmer's carry", "farmers carry"],
    "farmer's carry" => ["farmer carry", "farmers carry"],
    "bulgarian split-squat" => ["rear foot elevated split squat (bulgarian)", "bulgarian split squat"],
    "rear foot elevated split squat (bulgarian)" => ["bulgarian split-squat", "bulgarian split squat"],
    "incline db press" => ["incline dumbbell press", "incline db press"],
    "incline dumbbell press" => ["incline db press", "incline dumbbell press"],
    "single-arm db row" => ["single-arm dumbbell / meadows row", "single arm dumbbell row"],
    "single-arm dumbbell / meadows row" => ["single-arm db row", "single arm dumbbell row"],
    "bent-over row" => ["bent over row", "barbell row"],
    "ring row" => ["trx / ring row", "trx ring row"],
    "trx / ring row" => ["ring row", "trx ring row"],
    "rdl" => ["romanian deadlift", "rdl"],
    "romanian deadlift" => ["rdl", "romanian deadlift"],
    "single-leg rdl" => ["single-leg romanian deadlift", "single leg rdl"],
    "single-leg romanian deadlift" => ["single-leg rdl", "single leg rdl"]
  }
  
  # Check if either name has variations that match the other
  [norm1, norm2].each do |name|
    if variations[name]&.include?(norm1 == name ? norm2 : norm1)
      return true
    end
  end
  
  false
end

# Process each exercise from the JSON data
unified_exercises = exercises_data.map do |exercise|
  # Remove exercise_id field
  exercise.delete("exercise_id")
  
  # Get enhanced description
  enhanced_desc = ENHANCED_DESCRIPTIONS[exercise["exercise_name"]] || 
                  generate_enhanced_description(
                    exercise["exercise_name"], 
                    exercise["movement_pattern"], 
                    exercise["primary_muscles"]
                  )
  
  # Find workout contexts
  workout_contexts = find_workout_contexts(exercise["exercise_name"], program_data)
  
  # Build unified exercise entry
  {
    "exercise_name" => exercise["exercise_name"],
    "movement_pattern" => exercise["movement_pattern"],
    "primary_muscles" => exercise["primary_muscles"],
    "equipment_required" => exercise["equipment_required"],
    "training_effects" => exercise["training_effects"],
    "complexity_level" => exercise["complexity_level"],
    "effectiveness_score" => exercise["effectiveness_score"],
    "enhanced_description" => enhanced_desc,
    "workout_contexts" => workout_contexts,
    "is_in_programs" => workout_contexts.any?
  }
end

# Sort by effectiveness score (descending) then by name
unified_exercises.sort_by! { |ex| [-ex["effectiveness_score"], ex["exercise_name"]] }

# Output statistics
total_exercises = unified_exercises.length
exercises_in_programs = unified_exercises.count { |ex| ex["is_in_programs"] }
exercises_not_in_programs = total_exercises - exercises_in_programs

puts "=== Exercise Database Statistics ==="
puts "Total exercises: #{total_exercises}"
puts "Exercises used in programs: #{exercises_in_programs}"
puts "Exercises not in programs: #{exercises_not_in_programs}"
puts "Coverage: #{(exercises_in_programs.to_f / total_exercises * 100).round(1)}%"
puts

# Show some examples of exercises with workout contexts
puts "=== Examples of exercises with workout contexts ==="
unified_exercises.select { |ex| ex["is_in_programs"] }.first(5).each do |exercise|
  puts "#{exercise['exercise_name']} (#{exercise['workout_contexts'].length} contexts)"
  exercise['workout_contexts'].first(2).each do |context|
    puts "  - #{context[:program]} > #{context[:cycle]} > #{context[:session]}"
    puts "    #{context[:type]}: #{context[:sets]} sets, #{context[:reps]} reps"
  end
  puts
end

# Write the unified database to file
output_file = base_dir.join('db', 'unified_exercise_database.json')
File.write(output_file, JSON.pretty_generate(unified_exercises))

puts "=== Unified Exercise Database Generated ==="
puts "Output file: #{output_file}"
puts "File size: #{File.size(output_file)} bytes"
puts "#{unified_exercises.length} exercises processed successfully"