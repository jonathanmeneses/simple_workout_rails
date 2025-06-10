# WorkoutExercise Set Types & Display Logic

## Enum values (as of June 2025)

- `standard`: Regular sets (e.g., 3×8)
- `amrap`: As Many Reps As Possible (e.g., 2×8+)
- `cluster`: Cluster sets (e.g., 3×(3+3+3))
- `drop`: Drop set (e.g., 3×8→drop)

**Note:**  
Tempo and similar instructions (e.g., "3-1-X" or "Tempo: 4-0-2") are stored in the `notes` field, not as a set_type.

---

## Display logic

- Rendered using `display_sets_reps` helper in `app/models/workout_exercise.rb`
- Examples:
  - Standard: `3×8`
  - AMRAP: `2×8+`
  - Cluster: `3×9 cluster`
  - Drop: `3×8→drop`
  - If sets/reps are blank, display `"—"`

---

## Seeding & Data Model

- Seeds parse sets/reps as integers if possible.
- `set_type` is inferred from sets/reps/notes (see `guess_set_type!` in model).
- Tempo and other modifiers should be included in the `notes` field.

---

## Example seed entry

```ruby
{
  type: "main",
  name: "Back Squat",
  sets: 2,
  reps: 5,
  notes: "Tempo: 4-0-2, AMRAP on last set"
}
# set_type will be 'standard' (or 'amrap' if notes indicate so)
```

---

## Future extensibility

- If you need more granularity (e.g., per-set tempo, per-set logging), you can migrate to a more detailed model later.

---

_Last updated: 2025-06-10_