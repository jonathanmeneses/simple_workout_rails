# PRD-05: Adaptive Programming & Personalization

## Overview
Transform static workout programs into dynamic, adaptive plans that adjust based on user performance, recovery, and goals. Move beyond one-size-fits-all to truly personalized fitness programming.

## Background & Motivation
Current programs are static - same for beginners and advanced users. Real progress requires individualization based on recovery capacity, strength levels, weak points, and lifestyle factors. Users need programs that adapt to their actual performance, not theoretical models.

**Current Foundation Status (2025-01-06):**
- ✅ Complete exercise database with 223 fully-attributed exercises
- ✅ Standardized equipment system with 22 equipment types
- ✅ Functional substitution engine ready for intelligent exercise selection
- ✅ Rich exercise metadata (complexity levels, effectiveness scores, muscle targeting)

## Goals
1. Adjust workout difficulty based on performance
2. Personalize exercise selection to user level
3. Auto-regulate volume based on recovery
4. Adapt to missed workouts seamlessly
5. Progress users intelligently over time

## User Stories

### As a beginner
- I want exercises matched to my skill level
- I want the program to get harder as I improve
- I want form cues and safety warnings
- I want realistic progression targets

### As an intermediate lifter
- I want weak point identification and targeting
- I want periodized programming
- I want fatigue management
- I want plateau-breaking strategies

### As a busy professional
- I want workouts that adapt to my schedule
- I want shorter alternatives when pressed for time  
- I want to maintain progress with minimal time
- I want flexible workout ordering

## Functional Requirements

### User Profile Enhancement
```ruby
class UserProfile < ApplicationRecord
  belongs_to :user
  
  # Attributes
  # experience_level: :beginner, :intermediate, :advanced
  # training_age_months: integer
  # goals: [:strength, :muscle, :endurance, :weight_loss]
  # available_days_per_week: integer
  # average_session_duration: integer (minutes)
  # injury_considerations: jsonb
  # weak_points: jsonb
  # preferred_exercises: jsonb
  # avoided_exercises: jsonb
end
```

### Adaptive Algorithm Components

#### 1. Performance-Based Progression
```ruby
class ProgressionEngine
  def calculate_next_workout(user, exercise)
    recent_performance = analyze_recent_sets(user, exercise)
    
    case recent_performance
    when :exceeded_targets
      increase_weight(exercise, 5) # or add reps/sets
    when :met_targets  
      maintain_current(exercise)
    when :missed_targets
      decrease_load(exercise, 10) # or reduce volume
    when :consistently_failing
      suggest_regression(exercise) # easier variation
    end
  end
  
  def analyze_recent_sets(user, exercise)
    # Complex logic considering:
    # - RPE/RIR if tracked
    # - Completed vs prescribed reps
    # - Rest time needed
    # - Form breakdown notes
  end
end
```

#### 2. Auto-Regulation System
```ruby
class AutoRegulation
  def adjust_daily_workout(user, planned_workout)
    readiness_score = calculate_readiness(user)
    
    case readiness_score
    when 0..3
      reduce_volume(planned_workout, 40)
      suggest_message("Light day - focus on technique")
    when 4..6  
      reduce_volume(planned_workout, 20)
      suggest_message("Moderate intensity today")
    when 7..8
      planned_workout # As prescribed
    when 9..10
      add_backoff_sets(planned_workout)
      suggest_message("Feeling great! Extra volume added")
    end
  end
  
  private
  
  def calculate_readiness(user)
    factors = {
      sleep_quality: user.todays_sleep_score,
      muscle_soreness: user.soreness_rating,
      life_stress: user.stress_level,
      recent_performance: performance_trend(user)
    }
    
    weighted_average(factors)
  end
end
```

#### 3. Intelligent Exercise Selection
```ruby
class ExerciseSelector
  def select_appropriate_variation(user, movement_pattern)
    user_level = user.profile.experience_level
    available_equipment = user.available_equipment
    injury_considerations = user.profile.injury_considerations
    
    # Now working with 223 complete exercises with full attributes
    Exercise.where(movement_pattern: movement_pattern)
            .where(complexity_level: suitable_levels(user_level))
            .where("equipment_required <@ ?", available_equipment)
            .excluding_problematic(injury_considerations)
            .order_by_user_preference(user)
            .first
  end
  
  def suitable_levels(user_level)
    case user_level
    when :beginner
      [:beginner]
    when :intermediate  
      [:beginner, :intermediate]
    when :advanced
      [:intermediate, :advanced]
    end
  end
end
```

### UI Components

#### Daily Readiness Check
```
How are you feeling today?

Sleep: 😴 [1-2-3-4-5-6-7-8-9-10] 😊
Soreness: 💪 [1-2-3-4-5-6-7-8-9-10] 😖
Energy: ⚡ [1-2-3-4-5-6-7-8-9-10] 🚀
Stress: 😌 [1-2-3-4-5-6-7-8-9-10] 😰

[Auto-adjust workout] [Keep as planned]
```

#### Adaptive Workout Display
```
Today's Workout (Adapted) 

💡 "Reduced volume due to poor sleep"

Back Squat
3×5 @ 275 → 3×3 @ 250 (adjusted)

Romanian Deadlift  
3×8 @ 225 → 3×8 @ 205 (adjusted)

[Additional changes...]
```

#### Progress Insights
```
Your Personalized Insights

✅ Squat progressing faster than average
⚠️ Bench press lagging - added frequency
🎯 On track for 315lb squat by March
💡 Consider deload week after 2 more hard weeks
```

### Adaptation Rules

#### Missed Workout Handling
- 1 missed: Merge with next session
- 2 missed: Compress week's volume
- 3+ missed: Restart microcycle
- Vacation mode: Maintenance protocol

#### Plateau Breaking
- Stalled 2 weeks: Add variation
- Stalled 4 weeks: Change rep scheme  
- Stalled 6 weeks: Full exercise swap
- Stalled 8 weeks: Program pivot

## Implementation Phases

### Phase 1: User Profiling (Week 1)
- Create profile model and UI
- Collect baseline data
- Set up preference system
- Build readiness check

### Phase 2: Basic Adaptation (Week 2)
- Performance-based progression
- Simple auto-regulation
- Exercise level matching
- Missed workout handling

### Phase 3: Advanced Intelligence (Week 3-4)
- ML-based predictions
- Weak point analysis
- Periodization engine
- Recovery recommendations

## Success Metrics
- Program adherence > 85%
- User-reported satisfaction > 4.5/5
- Injury rate < 2%
- Progress rate +20% vs static programs
- Plateau duration -50%

## Privacy & Ethics
- All adaptation data stored locally
- Opt-in for aggregated analytics
- Clear explanation of adaptations
- User control over all changes
- No selling of health data

## Future Enhancements
- Wearable integration (HRV, sleep)
- Nutrition adaptation
- Competition peaking
- Team/coach collaboration
- Genetic testing integration
- Real-time form analysis