# Exercise Attribute Schema for N8N Workflow

## Required JSON Return Format

Each exercise needs the following attributes in JSON format:

```json
{
  "exercise_id": 2,
  "exercise_name": "Cyclist Squat",
  "primary_muscles": ["quads", "glutes"],
  "equipment_required": ["dumbbells", "bodyweight"],
  "training_effects": ["strength", "mobility"],
  "complexity_level": "beginner",
  "effectiveness_score": 7
}
```

## Schema Constraints

### primary_muscles (array of strings)
**Select 1-3 primary muscles that the exercise targets:**
- `quads` - Quadriceps
- `glutes` - Gluteus muscles
- `hamstrings` - Hamstring muscles
- `calves` - Calf muscles
- `chest` - Pectoral muscles
- `back` - General back muscles
- `lats` - Latissimus dorsi
- `traps` - Trapezius muscles
- `rhomboids` - Rhomboid muscles
- `front_delts` - Anterior deltoids
- `side_delts` - Lateral deltoids
- `rear_delts` - Posterior deltoids
- `triceps` - Tricep muscles
- `biceps` - Bicep muscles
- `forearms` - Forearm muscles
- `core` - Core stabilizers
- `abs` - Abdominal muscles
- `obliques` - Oblique muscles

### equipment_required (array of strings)
**Select all equipment needed for the exercise:**
- `barbell` - Barbell
- `dumbbells` - Dumbbells
- `kettlebell` - Kettlebell
- `bodyweight` - No equipment needed
- `bench` - Weight bench
- `squat_rack` - Squat rack/power rack
- `pull_up_bar` - Pull-up bar
- `resistance_bands` - Resistance bands
- `medicine_ball` - Medicine ball
- `cable_machine` - Cable machine
- `trap_bar` - Trap bar/hex bar
- `safety_bar` - Safety squat bar

### training_effects (array of strings)
**Select 1-2 primary training effects:**
- `strength` - Develops maximal strength
- `power` - Develops explosive power
- `endurance` - Develops muscular endurance
- `mobility` - Improves range of motion
- `stability` - Improves balance/stability
- `speed` - Develops movement speed
- `unilateral` - Single-limb training

### complexity_level (single string)
**Select one complexity level:**
- `beginner` - Easy to learn, minimal risk
- `intermediate` - Moderate complexity, some technique required
- `advanced` - High complexity, significant technique required

### effectiveness_score (integer 1-10)
**Rate the exercise's effectiveness for its intended purpose:**
- `1-3` - Low effectiveness, very niche or rehabilitative
- `4-6` - Moderate effectiveness, good accessory exercise
- `7-8` - High effectiveness, excellent exercise
- `9-10` - Maximum effectiveness, gold standard exercise

## Status
- **Total exercises**: 96
- **Already populated**: 7 exercises (Back Squat, Goblet Squat, Bench Press, Deadlift, OHP, Chin-ups, Ring Row)
- **Need attributes**: **89 exercises** (see exercise_attributes_needed.csv)

## ⚠️ CRITICAL ISSUE: Incorrect Movement Patterns
**The CSV shows many exercises have WRONG movement patterns** (e.g., OHP showing as "squat" instead of "vertical_push"). This is why the substitution system is broken (Goblet Squat appearing as substitute for OHP).

**When providing exercise data, please ALSO include a corrected movement_pattern field:**

```json
{
  "exercise_id": 51,
  "exercise_name": "Overhead Press (OHP)",
  "movement_pattern": "vertical_push",  // ← CORRECT THIS
  "primary_muscles": ["front_delts", "triceps", "core"],
  "equipment_required": ["barbell"],
  "training_effects": ["strength"],
  "complexity_level": "intermediate",
  "effectiveness_score": 9
}
```

**Valid movement patterns:**
- `squat` - Squatting movements
- `hinge` - Hip hinge movements (deadlifts, RDLs)
- `horizontal_push` - Bench press, push-ups
- `horizontal_pull` - Rows
- `vertical_push` - Overhead press, Z press
- `vertical_pull` - Pull-ups, chin-ups
- `lunge` - Split squats, lunges
- `carry` - Farmer's walks, loaded carries
- `core` - Core stabilization exercises
- `core_rotation` - Rotational core exercises

## Examples

### Main Movement (High Effectiveness)
```json
{
  "exercise_id": 8,
  "exercise_name": "Conventional Deadlift",
  "primary_muscles": ["hamstrings", "glutes", "back"],
  "equipment_required": ["barbell"],
  "training_effects": ["strength"],
  "complexity_level": "intermediate",
  "effectiveness_score": 9
}
```

### Accessory Movement (Moderate Effectiveness)
```json
{
  "exercise_id": 19,
  "exercise_name": "Push-Up",
  "primary_muscles": ["chest", "triceps", "core"],
  "equipment_required": ["bodyweight"],
  "training_effects": ["strength", "endurance"],
  "complexity_level": "beginner",
  "effectiveness_score": 6
}
```

### Unilateral Movement
```json
{
  "exercise_id": 12,
  "exercise_name": "Single-Leg Romanian Deadlift",
  "primary_muscles": ["hamstrings", "glutes"],
  "equipment_required": ["dumbbells"],
  "training_effects": ["strength", "stability", "unilateral"],
  "complexity_level": "advanced",
  "effectiveness_score": 7
}
```