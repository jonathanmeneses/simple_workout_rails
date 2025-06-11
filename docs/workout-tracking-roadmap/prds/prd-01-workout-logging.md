# PRD-01: Basic Workout Logging System

## Overview
Enable users to log their actual workouts, tracking sets, reps, and weights for each exercise in a session. This foundational feature transforms the app from a program viewer to an active workout companion.

## Background & Motivation
Currently, users can view workout programs but cannot track their actual performance. This creates a gap between planning and execution. Users need to record what they actually did (vs. what was prescribed) to track progress over time.

## Goals
1. Allow users to log workouts in real-time during their gym session
2. Track actual vs. prescribed sets/reps/weight
3. Store workout history for future analysis
4. Maintain simple, mobile-friendly interface
5. Support offline capability with sync when online

## User Stories

### As a gym user
- I want to log my sets/reps/weight as I complete them
- I want to see what I lifted last time for each exercise
- I want to mark exercises as complete
- I want to add notes about form or feeling

### As a returning user
- I want to see my workout history
- I want to resume an incomplete workout
- I want to copy a previous workout's numbers

## Functional Requirements

### Data Model
```ruby
# New Models
class WorkoutLog < ApplicationRecord
  belongs_to :user
  belongs_to :workout_session
  has_many :exercise_logs, dependent: :destroy
  
  # status: :planned, :in_progress, :completed, :skipped
  # started_at, completed_at, notes
end

class ExerciseLog < ApplicationRecord
  belongs_to :workout_log
  belongs_to :workout_exercise
  has_many :set_logs, dependent: :destroy
  
  # actual_exercise_id (for substitutions), notes, skipped
end

class SetLog < ApplicationRecord
  belongs_to :exercise_log
  
  # set_number, target_reps, actual_reps, target_weight, actual_weight
  # weight_unit (:lbs, :kg), completed, notes
end
```

### UI Components

#### Workout Session View Enhancement
- "Start Workout" button on session page
- Progress indicator (3/5 exercises complete)
- Timer showing workout duration

#### Exercise Logging Card
```
[Exercise Name]
Last time: 3×10 @ 135lbs

Set 1: [10] reps @ [135] lbs ✓
Set 2: [10] reps @ [135] lbs ✓  
Set 3: [ 8] reps @ [135] lbs ✓
[+ Add Set]

[Notes: "Felt strong today, could go heavier"]
```

#### Quick Actions
- "Use Previous" button to copy last workout's numbers
- "Skip Exercise" with reason selection
- "Add Warm-up Set" option

### Technical Requirements

#### Turbo Frames/Streams
- Each exercise card is a Turbo Frame for independent updates
- Real-time save without page reload
- Optimistic UI updates with rollback on error

#### Offline Support
- Use localStorage for offline data
- Sync queue for when connection returns
- Visual indicator of sync status

#### Mobile Optimizations
- Large touch targets (44×44px minimum)
- Number inputs with numeric keyboard
- Swipe gestures for set completion
- Prevent screen sleep during workout

## Non-Functional Requirements

### Performance
- Set logging < 100ms response time
- Offline-first architecture
- Background auto-save every 30 seconds

### Usability
- One-thumb operation on mobile
- Clear visual feedback for all actions
- Undo capability for recent actions

## Success Metrics
- 80% of users who start a workout complete it
- Average logging time per set < 5 seconds
- <1% data loss from sync issues
- 90% mobile vs desktop usage

## Implementation Phases

### Phase 1: Core Logging (Week 1)
- Create models and migrations
- Basic workout start/stop flow
- Simple set logging UI

### Phase 2: Enhanced UX (Week 2)
- Previous workout display
- Quick-fill options
- Exercise notes

### Phase 3: Offline & Polish (Week 3)
- Offline support
- Sync mechanism
- Mobile optimizations

## Edge Cases
- User loses connection mid-workout
- User accidentally closes app
- Switching between lb/kg units
- Logging bodyweight exercises
- Superset/circuit training

## Future Enhancements
- Rest timer between sets
- Plate calculator
- Video form check
- RPE/RIR tracking
- Heart rate integration