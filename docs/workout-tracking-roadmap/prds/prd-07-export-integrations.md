# PRD-07: Data Export & Third-Party Integrations

## Overview
Enable users to export their workout data in multiple formats and integrate with popular fitness platforms, wearables, and health apps. Ensure users truly own their fitness data while expanding the app's ecosystem.

## Background & Motivation
Users invest significant time logging workouts and want to: analyze data in spreadsheets, share with coaches/doctors, backup their progress, and sync with other fitness tools. Data portability builds trust and prevents vendor lock-in. Integrations expand functionality without building everything in-house.

## Goals
1. Provide comprehensive data export options
2. Integrate with major fitness platforms
3. Support wearable device sync
4. Enable coaching/medical professional sharing
5. Ensure GDPR/privacy compliance

## User Stories

### As a data-conscious user
- I want to export all my workout history
- I want regular automated backups
- I want to analyze data in Excel
- I want to switch apps without losing data

### As a multi-app user
- I want to sync with MyFitnessPal for calories
- I want Strava integration for cardio
- I want Apple Health to track everything
- I want my Garmin watch to show workouts

### As a coached athlete
- I want to share data with my coach
- I want to import coach's programs  
- I want medical export for PT/doctor
- I want competition prep reports

## Functional Requirements

### Export Formats

#### 1. CSV Export
```csv
# workout_history.csv
Date,Exercise,Sets,Reps,Weight,Weight_Unit,Notes,Duration
2025-01-15,Back Squat,3,5,315,lbs,Felt strong,1:32:45
2025-01-15,Bench Press,3,8,225,lbs,Slight shoulder pain,
2025-01-15,Bent Over Row,3,10,185,lbs,,

# personal_records.csv  
Exercise,Weight,Reps,Date,Bodyweight,Notes
Back Squat,325,3,2025-01-10,185,Competition PR
Deadlift,405,1,2025-01-08,185,Finally hit 405!
```

#### 2. JSON Export
```json
{
  "export_date": "2025-01-15",
  "user": {
    "created_at": "2024-06-01",
    "stats": {
      "total_workouts": 145,
      "total_volume": 1847650,
      "workout_days": 142
    }
  },
  "programs": [...],
  "workouts": [
    {
      "date": "2025-01-15",
      "program": "Starting Strength",
      "session": "Workout A",
      "duration_minutes": 93,
      "exercises": [...]
    }
  ],
  "personal_records": [...]
}
```

#### 3. PDF Reports
```
WORKOUT HISTORY REPORT
Generated: January 15, 2025

User: John Doe
Training Since: June 1, 2024
Total Workouts: 145

RECENT PERSONAL RECORDS
- Back Squat: 325 lbs × 3 (Jan 10)
- Deadlift: 405 lbs × 1 (Jan 8)
- Bench Press: 245 lbs × 5 (Jan 5)

[Charts and graphs included]
[Full workout history follows...]
```

### Integration Partners

#### Health Platforms
```ruby
class HealthKitIntegration
  def sync_workout(workout_log)
    # Apple HealthKit
    HKWorkout.create(
      activityType: .traditionalStrengthTraining,
      start: workout_log.started_at,
      end: workout_log.completed_at,
      duration: workout_log.duration,
      totalEnergyBurned: estimate_calories(workout_log),
      metadata: {
        'HKMetadataKeyWorkoutBrandName' => 'Simple Workout Tracking',
        'exercises' => format_exercises(workout_log)
      }
    )
  end
end

class GoogleFitIntegration
  # Similar for Google Fit API
end
```

#### Nutrition Apps
- **MyFitnessPal**: Calorie burn estimates
- **Cronometer**: Detailed exercise data
- **MacroFactor**: Training volume sync
- **Carbon Diet Coach**: Activity levels

#### Wearables
```javascript
// Garmin Connect IQ App
class WorkoutSyncApp extends WatchApp {
  function syncTodaysWorkout() {
    // Download today's workout
    // Display on watch
    // Track rest periods
    // Log completed sets
  }
}
```

Supported devices:
- Apple Watch (native app)
- Garmin (Connect IQ)  
- Fitbit (Web API)
- Whoop (recovery data)
- Polar (heart rate)

#### Coaching Platforms
- **TrainerRoad**: Strength blocks
- **TrainingPeaks**: TSS calculations
- **TrueCoach**: Program import/export
- **Coach's Eye**: Video form checks

### API Access

#### Public API
```ruby
# api/v1/workouts_controller.rb
class Api::V1::WorkoutsController < ApiController
  before_action :authenticate_api_user!
  
  # GET /api/v1/workouts
  def index
    @workouts = current_user.workout_logs
                           .includes(:exercise_logs)
                           .page(params[:page])
    
    render json: WorkoutSerializer.new(@workouts)
  end
  
  # POST /api/v1/workouts
  def create
    # Allow external apps to log workouts
  end
end
```

#### Webhooks
```ruby
class Webhook < ApplicationRecord
  # Events:
  # - workout.completed
  # - pr.achieved  
  # - program.finished
  # - weight.updated
  
  def deliver(event)
    HTTParty.post(url, 
      body: event.to_json,
      headers: {
        'X-Signature' => generate_signature(event)
      }
    )
  end
end
```

### Privacy & Security

#### Data Controls
```
Privacy Settings

Data Sharing:
□ Share with Apple Health
□ Share with coaching apps
□ Anonymous analytics
□ Public progress updates

Export Settings:
□ Include personal info
□ Include photos
□ Include measurements
□ Include notes

Automated Backups:
○ Off ● Weekly ○ Monthly
Email: user@example.com
```

#### GDPR Compliance
- Export all data within 24 hours
- Delete all data on request
- Clear audit trail of sharing
- Granular consent options
- Data processing agreements

### UI Components

#### Export Center
```
Export Your Data

Quick Export:
[Last 30 Days ▼] [CSV] [Export]

Full Export:
[All Time] [JSON] [Export]

Automated Backups: Weekly to email
Last backup: Jan 8, 2025

Connected Apps:
- Apple Health ✓ [Disconnect]
- MyFitnessPal ✓ [Settings]
- Garmin Connect ✗ [Connect]
```

#### Integration Settings
```
App Integrations

Fitness Apps:
┌─────────────────────────┐
│ MyFitnessPal           │
│ ✓ Connected            │
│ Syncs: Calories burned │
│ [Settings] [Disconnect]│
└─────────────────────────┘

┌─────────────────────────┐
│ Strava                 │
│ ✗ Not connected        │
│ Syncs: Cardio workouts │
│ [Connect]              │
└─────────────────────────┘

[Discover more apps...]
```

## Implementation Phases

### Phase 1: Basic Export (Week 1)
- CSV export functionality
- JSON export option
- Email delivery system
- Export UI page

### Phase 2: Health Platform Integration (Week 2)
- Apple Health sync
- Google Fit sync
- Basic calorie estimates
- Privacy controls

### Phase 3: API & Webhooks (Week 3)
- Public API v1
- API documentation
- Webhook system
- Rate limiting

### Phase 4: Partner Integrations (Week 4)
- MyFitnessPal OAuth
- Strava integration
- Garmin Connect
- TrainingPeaks sync

## Success Metrics
- 40% of users export data at least once
- 25% connect at least one integration
- <2% data sync errors
- API uptime > 99.9%
- Partner app ratings > 4.0

## Technical Considerations

### Performance
- Background jobs for large exports
- Chunked downloads for big files
- CDN for API responses
- Caching for repeated exports

### Scalability
- Queue system for exports
- Rate limiting per user
- Webhook retry logic
- Partner API quotas

## Future Enhancements
- Real-time streaming API
- GraphQL endpoint
- Zapier integration
- IFTTT recipes
- Blockchain workout verification
- FIT file format support