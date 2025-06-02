# Hardcoded workout program data (converted from YAML to avoid parsing issues)
# This replaces the dependency on config/demo_programs.yml

HARDCODED_PROGRAM_DATA = {
  "1" => {
    name: "3-Day Full Body Program",
    description: "3-Day Full Body program with functional bodybuilding principles",
    cycles: [
      {
        name: "Base Strength",
        description: "Focus on building foundational strength with compound movements. Emphasize proper form and progressive overload.",
        days: [
          {
            title: "FB-A: Squat Focus",
            exercises: [
              { type: "main", name: "Back Squat", sets: "2×5", reps: "+ AMRAP", notes: "Main strength movement" },
              { type: "main", name: "Overhead Press (OHP)", sets: "2×5", reps: "+ AMRAP", notes: "Upper body strength" },
              { type: "accessory", name: "Chin-ups", sets: 3, reps: "AMRAP", notes: "Vertical pull" },
              { type: "accessory", name: "Nordic Curl", sets: 3, reps: "6-8", notes: "Hamstring eccentric" },
              { type: "accessory", name: "Pallof Press", sets: 3, reps: "10/side", notes: "Anti-rotation core" }
            ]
          },
          {
            title: "FB-B: Power & Deadlift",
            exercises: [
              { type: "main", name: "Power Clean", sets: 3, reps: "3 @ 60-70%", notes: "Explosive power" },
              { type: "main", name: "Deadlift", sets: 1, reps: "5", notes: "Heavy single set" },
              { type: "main", name: "Bench Press", sets: "2×5", reps: "+ AMRAP", notes: "Horizontal push" },
              { type: "accessory", name: "Chest-Supported Row", sets: 3, reps: "10", notes: "Horizontal pull" },
              { type: "accessory", name: "Hip Thrust", sets: 3, reps: "10", notes: "Glute activation" },
              { type: "accessory", name: "GHD Sit-up", sets: 3, reps: "12", notes: "Posterior chain core" }
            ]
          },
          {
            title: "FB-C: Squat & Press Variation",
            exercises: [
              { type: "main", name: "Back Squat", sets: 2, reps: "5", notes: "Match Monday's weight" },
              { type: "main", name: "Bench or OHP (alternate weekly)", sets: "2×5", reps: "+ AMRAP", notes: "Press variation" },
              { type: "accessory", name: "Ring Row", sets: 3, reps: "AMRAP", notes: "Bodyweight pull" },
              { type: "accessory", name: "Bulgarian Split-Squat", sets: 3, reps: "8/leg", notes: "Unilateral leg" },
              { type: "accessory", name: "Farmer Carry", sets: 3, reps: "30m", notes: "Loaded carry" }
            ]
          }
        ]
      },
      {
        name: "Unilateral & Core",
        description: "Emphasis shifts to unilateral movements and core stability. This phase challenges balance, coordination, and addresses strength imbalances.",
        days: [
          {
            title: "FB-A: Unilateral & Core Focus",
            exercises: [
              { type: "main", name: "Cyclist Squat (heels elevated)", sets: "2×5", reps: "+ AMRAP", notes: "Knee/quad bias variation" },
              { type: "accessory", name: "Tall-Kneel Landmine Press", sets: 3, reps: "8/arm", notes: nil },
              { type: "accessory", name: "Neutral-Grip Pull-up", sets: 3, reps: "8", notes: "Core-stabilized pull" },
              { type: "accessory", name: "Single-Leg RDL", sets: 3, reps: "8/leg", notes: "Unilateral hinge" },
              { type: "accessory", name: "Suitcase Carry", sets: 3, reps: "40m", notes: "Anti-lateral flexion" }
            ]
          },
          {
            title: "FB-B: Unilateral Power & Core",
            exercises: [
              { type: "main", name: "Hang Power Clean", sets: 4, reps: "2 @ 70%", notes: "Explosive from hang" },
              { type: "main", name: "Trap-Bar Deadlift", sets: 1, reps: "5", notes: "Neutral grip variation" },
              { type: "accessory", name: "Incline DB Press", sets: 3, reps: "8", notes: "Unilateral option" },
              { type: "accessory", name: "Single-Arm DB Row", sets: 3, reps: "10/arm", notes: "Unilateral pull" },
              { type: "accessory", name: "Zercher Good Morning", sets: 3, reps: "8", notes: "Front-loaded hinge" },
              { type: "accessory", name: "Weighted Dead-Bug", sets: 3, reps: "10", notes: "Core coordination" }
            ]
          },
          {
            title: "FB-C: Unilateral Strength",
            exercises: [
              { type: "main", name: "Zercher Squat", sets: 3, reps: "6", notes: "Front-loaded squat" },
              { type: "main", name: "Seated Z-Press", sets: 3, reps: "6", notes: "No back support" },
              { type: "accessory", name: "Ring Pull-up (Tempo 3-1-X)", sets: 3, reps: "5", notes: "Controlled tempo" },
              { type: "accessory", name: "Front-Rack Reverse Lunge", sets: 3, reps: "8/leg", notes: "Front-loaded unilateral" },
              { type: "accessory", name: "Front-Rack Carry", sets: 3, reps: "30m", notes: "Front-loaded carry" }
            ]
          }
        ]
      },
      {
        name: "Power & Plyometrics",
        description: "Peak phase focusing on power and plyometric development. Exercises emphasize speed, explosiveness, and athletic performance.",
        days: [
          {
            title: "FB-A: Power & Plyometrics",
            exercises: [
              { type: "main", name: "Jump Squat", sets: 5, reps: "3", notes: "Bodyweight or light KB" },
              { type: "main", name: "Pause Back Squat", sets: 2, reps: "5", notes: "3-sec pause" },
              { type: "main", name: "Push-Press", sets: 5, reps: "3 @ 70%", notes: "Explosive press" },
              { type: "accessory", name: "Chest-to-Bar Pull-up", sets: 5, reps: "3", notes: "Explosive pull" },
              { type: "accessory", name: "Kettlebell Swing", sets: 4, reps: "15", notes: "Hip snap power" },
              { type: "accessory", name: "Med-ball Slam", sets: 3, reps: "8", notes: "Explosive torso" }
            ]
          },
          {
            title: "FB-B: Speed & Power",
            exercises: [
              { type: "main", name: "Hang-Clean Pulls", sets: 5, reps: "2", notes: "Speed focus" },
              { type: "main", name: "Deficit Deadlift (lighter)", sets: 1, reps: "5", notes: "Increased ROM" },
              { type: "accessory", name: "Plyo Push-ups", sets: 4, reps: "5", notes: "Explosive push" },
              { type: "accessory", name: "Pendlay Row", sets: 4, reps: "6", notes: "Dead stop rows" },
              { type: "accessory", name: "Hip Thrust (band-resist)", sets: 4, reps: "15", notes: "Band tension" },
              { type: "accessory", name: "Strict Toes-to-Bar", sets: 3, reps: "8", notes: "Hanging core" }
            ]
          },
          {
            title: "FB-C: Speed & Plyometrics",
            exercises: [
              { type: "main", name: "Speed Front Squat", sets: 6, reps: "3 @ 55-60%", notes: "Speed emphasis" },
              { type: "accessory", name: "Bradford Press (light)", sets: 4, reps: "8", notes: "No lockout" },
              { type: "accessory", name: "Ring Muscle-up Row", sets: 4, reps: "6", notes: "Transition prep" },
              { type: "accessory", name: "Jump Switch Lunges", sets: 3, reps: "10/leg", notes: "Plyo-focused lunge" },
              { type: "accessory", name: "Overhead Plate Carry", sets: 3, reps: "30m", notes: "Overhead stability" }
            ]
          }
        ]
      }
    ]
  },
  "2" => {
    name: "4-Day Upper/Lower Split",
    description: "4-Day Upper/Lower Split for targeted muscle development",
    cycles: [
      {
        name: "Base Strength",
        description: "Focus on building foundational strength with compound movements. Emphasize proper form and progressive overload.",
        days: [
          {
            title: "Upper 1: Horizontal Push/Pull",
            exercises: [
              { type: "main", name: "Bench Press", sets: "2×5", reps: "+ AMRAP", notes: "Main horizontal push" },
              { type: "accessory", name: "Bent-over Row", sets: 3, reps: "8", notes: "Horizontal pull" },
              { type: "accessory", name: "Incline DB Press", sets: 3, reps: "8", notes: "Upper chest" },
              { type: "accessory", name: "Face Pull", sets: 3, reps: "15", notes: "Rear delt/upper back" },
              { type: "accessory", name: "Dips", sets: 3, reps: "10", notes: "Tricep/chest" }
            ]
          },
          {
            title: "Lower 1: Squat Focus",
            exercises: [
              { type: "main", name: "Back Squat", sets: "2×5", reps: "+ AMRAP", notes: "Main leg movement" },
              { type: "accessory", name: "RDL", sets: 3, reps: "8", notes: "Posterior chain" },
              { type: "accessory", name: "Bulgarian Split-Squat", sets: 3, reps: "8/leg", notes: "Unilateral strength" },
              { type: "accessory", name: "Nordic Curl", sets: 3, reps: "6", notes: "Hamstring eccentric" }
            ]
          },
          {
            title: "Upper 2: Vertical Push/Pull",
            exercises: [
              { type: "main", name: "Overhead Press", sets: "2×5", reps: "+ AMRAP", notes: "Vertical push" },
              { type: "accessory", name: "Weighted Pull-up", sets: 3, reps: "5-8", notes: "Vertical pull" },
              { type: "accessory", name: "Landmine One-Arm Press", sets: 3, reps: "10/arm", notes: "Unilateral press" },
              { type: "accessory", name: "Lateral Raise", sets: 3, reps: "12", notes: "Deltoid isolation" },
              { type: "accessory", name: "Curls", sets: 3, reps: "12", notes: "Bicep isolation" }
            ]
          },
          {
            title: "Lower 2: Power & Deadlift",
            exercises: [
              { type: "main", name: "Power Clean", sets: 4, reps: "2 @ 65-70%", notes: "Explosive power" },
              { type: "main", name: "Deadlift", sets: 1, reps: "5", notes: "Heavy single set" },
              { type: "accessory", name: "Hip Thrust", sets: 3, reps: "10", notes: "Glute focus" },
              { type: "accessory", name: "Good Morning", sets: 3, reps: "10", notes: "Posterior chain" },
              { type: "accessory", name: "Plank", sets: 3, reps: "60s", notes: "Core stability" }
            ]
          }
        ]
      }
      # Note: Add other cycles for 4-day program as needed
    ]
  }
}