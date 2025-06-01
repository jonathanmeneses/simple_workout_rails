# Rails 8 Workout Tracker Implementation Plan

## Overview
Transform the existing Next.js workout tracker into a Rails 8 application with database persistence, user accounts, and equipment-based exercise substitutions. This plan maintains the core functionality while adding robust backend features for progress tracking and personalization.

## Rails 8 Features to Leverage
- **Solid Cache/Queue**: For background job processing
- **Authentication**: Built-in authentication generators
- **Hotwire**: Turbo + Stimulus for SPA-like experience
- **Importmaps**: Asset management without Node.js
- **ViewComponent**: Component-based architecture

## Phase 1: Foundation & Data Migration (Weeks 1-2)

### 1.1 Project Setup
```bash
rails new workout_tracker_rails --database=postgresql
cd workout_tracker_rails
bundle add tailwindcss-rails view_component hotwire-rails
```

### 1.2 Core Models
Create the foundational data structure:

```ruby
# app/models/equipment.rb
class Equipment < ApplicationRecord
  has_many :exercise_equipment_requirements
  has_many :exercises, through: :exercise_equipment_requirements
  has_many :user_equipment
  has_many :users, through: :user_equipment
end

# app/models/exercise.rb
class Exercise < ApplicationRecord
  belongs_to :movement_pattern
  has_many :exercise_equipment_requirements
  has_many :required_equipment, through: :exercise_equipment_requirements, source: :equipment
  has_many :exercise_alternatives
  has_many :alternatives, through: :exercise_alternatives
  
  enum exercise_type: { main: 0, accessory: 1 }
  
  def alternatives_for_equipment(available_equipment_ids)
    # Logic for equipment-based substitutions
  end
end

# app/models/movement_pattern.rb
class MovementPattern < ApplicationRecord
  has_many :exercises
  # e.g., "squat", "hinge", "horizontal_push", "vertical_pull"
end

# app/models/workout_program.rb
class WorkoutProgram < ApplicationRecord
  has_many :workout_cycles
  has_many :workout_sessions, through: :workout_cycles
  
  enum program_type: { three_day: 0, four_day: 1 }
end

# app/models/workout_cycle.rb
class WorkoutCycle < ApplicationRecord
  belongs_to :workout_program
  has_many :workout_sessions
  
  enum cycle_type: { base_strength: 0, unilateral_core: 1, power_plyometrics: 2 }
end

# app/models/workout_session.rb
class WorkoutSession < ApplicationRecord
  belongs_to :workout_cycle
  has_many :workout_exercises
  has_many :exercises, through: :workout_exercises
end

# app/models/workout_exercise.rb
class WorkoutExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise
  # sets, reps, notes, order_position
end
```

### 1.3 Data Migration Strategy
Convert existing TypeScript data to Rails seeds:

```ruby
# db/seeds.rb
# Parse existing workout-programs.ts data
# Create Equipment records (barbell, dumbbells, rings, etc.)
# Create MovementPattern records
# Create WorkoutProgram, WorkoutCycle, WorkoutSession records
# Establish exercise alternatives based on equipment requirements
```

### 1.4 Authentication Setup
```ruby
# Use Rails 8 built-in authentication
rails generate authentication User
```

## Phase 2: User Features & Equipment Management (Weeks 3-4)

### 2.1 User Equipment Tracking
```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_many :user_equipment
  has_many :equipment, through: :user_equipment
  has_many :user_workout_sessions
  has_many :exercise_logs, through: :user_workout_sessions
  
  def available_equipment_ids
    equipment.pluck(:id)
  end
  
  def personalized_program(program_type, cycle_type)
    # Generate program with equipment substitutions
  end
end

# app/models/user_equipment.rb
class UserEquipment < ApplicationRecord
  belongs_to :user
  belongs_to :equipment
end
```

### 2.2 Equipment Management Interface
```ruby
# app/controllers/equipment_controller.rb
class EquipmentController < ApplicationController
  def index
    @available_equipment = Equipment.all
    @user_equipment = current_user.equipment
  end
  
  def update
    # Handle equipment selection with Turbo
  end
end
```

### 2.3 ViewComponents for UI
```ruby
# app/components/equipment_selector_component.rb
class EquipmentSelectorComponent < ViewComponent::Base
  def initialize(user:, equipment:)
    @user = user
    @equipment = equipment
  end
end

# app/components/workout_card_component.rb
class WorkoutCardComponent < ViewComponent::Base
  def initialize(workout_session:, user_equipment: [])
    @workout_session = workout_session
    @user_equipment = user_equipment
  end
  
  private
  
  def personalized_exercises
    @workout_session.workout_exercises.map do |workout_exercise|
      PersonalizedExerciseService.new(
        workout_exercise, 
        @user_equipment
      ).call
    end
  end
end
```

## Phase 3: Progress Tracking & Logging (Weeks 5-6)

### 3.1 Workout Logging Models
```ruby
# app/models/user_workout_session.rb
class UserWorkoutSession < ApplicationRecord
  belongs_to :user
  belongs_to :workout_session
  has_many :exercise_logs
  
  enum status: { planned: 0, in_progress: 1, completed: 2 }
end

# app/models/exercise_log.rb
class ExerciseLog < ApplicationRecord
  belongs_to :user_workout_session
  belongs_to :exercise
  belongs_to :workout_exercise
  
  # weight, sets_completed, reps_completed, rpe, notes
  
  def next_recommended_weight
    ProgressionService.new(self).next_weight
  end
end
```

### 3.2 Progress Tracking Service
```ruby
# app/services/progression_service.rb
class ProgressionService
  def initialize(exercise_log)
    @exercise_log = exercise_log
    @user = exercise_log.user_workout_session.user
  end
  
  def next_weight
    # Implement AMRAP-based progression logic
    # +5 lb (lower body) / +2.5 lb (upper body) when AMRAP ≥5 reps
  end
  
  def suggest_deload?
    # Check if user needs deload week
  end
end
```

### 3.3 Workout Session Interface
```ruby
# app/controllers/workout_sessions_controller.rb
class WorkoutSessionsController < ApplicationController
  def show
    @workout_session = WorkoutSession.find(params[:id])
    @user_session = current_user.user_workout_sessions
                               .find_or_create_by(workout_session: @workout_session)
    @exercise_logs = @user_session.exercise_logs.includes(:exercise)
  end
  
  def start
    # Begin workout session
    respond_to do |format|
      format.html { redirect_to workout_session_path(@workout_session) }
      format.turbo_stream
    end
  end
end
```

## Phase 4: Hotwire Interactivity (Weeks 7-8)

### 4.1 Stimulus Controllers
```javascript
// app/javascript/controllers/workout_logger_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["weight", "reps", "sets"]
  static values = { exerciseLogId: Number }
  
  connect() {
    this.autoSave = this.debounce(this.save.bind(this), 1000)
  }
  
  updateWeight() {
    this.autoSave()
  }
  
  updateReps() {
    this.autoSave()
  }
  
  save() {
    // Auto-save workout progress
    fetch(`/exercise_logs/${this.exerciseLogIdValue}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({
        exercise_log: {
          weight: this.weightTarget.value,
          reps_completed: this.repsTarget.value,
          sets_completed: this.setsTarget.value
        }
      })
    })
  }
}

// app/javascript/controllers/program_selector_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["programType", "cycle", "viewMode"]
  
  updateProgram() {
    // Update program view with Turbo
    const formData = new FormData()
    formData.append("program_type", this.programTypeTarget.value)
    formData.append("cycle", this.cycleTarget.value)
    formData.append("view_mode", this.viewModeTarget.value)
    
    fetch("/workout_programs/preview", {
      method: "POST",
      body: formData,
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
  }
}
```

### 4.2 Turbo Streams for Real-time Updates
```erb
<!-- app/views/workout_sessions/_exercise_log.html.erb -->
<%= turbo_frame_tag "exercise_log_#{exercise_log.id}" do %>
  <div data-controller="workout-logger" 
       data-workout-logger-exercise-log-id-value="<%= exercise_log.id %>">
    <input type="number" 
           data-workout-logger-target="weight" 
           data-action="change->workout-logger#updateWeight"
           value="<%= exercise_log.weight %>" 
           placeholder="Weight">
    <!-- More form fields -->
  </div>
<% end %>
```

## Phase 5: PDF Generation & Mobile Optimization (Weeks 9-10)

### 5.1 PDF Generation with Prawn
```ruby
# app/services/workout_pdf_service.rb
class WorkoutPdfService
  def initialize(workout_session, user)
    @workout_session = workout_session
    @user = user
  end
  
  def generate
    Prawn::Document.new do |pdf|
      pdf.text @workout_session.title, size: 20, style: :bold
      
      @workout_session.personalized_exercises(@user.available_equipment_ids).each do |exercise|
        # Generate PDF content similar to React PDF component
      end
    end
  end
end

# app/controllers/workout_sessions_controller.rb
def download_pdf
  pdf_service = WorkoutPdfService.new(@workout_session, current_user)
  pdf_content = pdf_service.generate
  
  send_data pdf_content.render,
            filename: "workout-#{@workout_session.id}.pdf",
            type: "application/pdf",
            disposition: "attachment"
end
```

### 5.2 Mobile-First Responsive Design
```scss
// app/assets/stylesheets/application.tailwind.css
// Use Tailwind responsive utilities
.workout-card {
  @apply md:grid md:grid-cols-2 lg:grid-cols-3;
}

.exercise-input {
  @apply text-base md:text-sm; /* Larger touch targets on mobile */
}
```

## Phase 6: Advanced Features (Weeks 11-12)

### 6.1 Equipment-Based Exercise Substitution
```ruby
# app/services/exercise_substitution_service.rb
class ExerciseSubstitutionService
  def initialize(exercise, available_equipment)
    @exercise = exercise
    @available_equipment = available_equipment
  end
  
  def substitute
    return @exercise if has_required_equipment?
    
    # Find alternative exercise with same movement pattern
    @exercise.movement_pattern.exercises
             .joins(:required_equipment)
             .where(equipment: { id: @available_equipment })
             .where.not(id: @exercise.id)
             .first || default_bodyweight_alternative
  end
  
  private
  
  def has_required_equipment?
    (@exercise.required_equipment.pluck(:id) - @available_equipment.pluck(:id)).empty?
  end
end
```

### 6.2 Workout Program Generator
```ruby
# app/controllers/workout_programs_controller.rb
class WorkoutProgramsController < ApplicationController
  def show
    @program = WorkoutProgram.find(params[:id])
    @personalized_cycles = @program.workout_cycles.map do |cycle|
      PersonalizedCycleService.new(cycle, current_user).call
    end
  end
  
  def preview
    # Handle dynamic program preview with Turbo
    respond_to do |format|
      format.turbo_stream do
        @preview = WorkoutProgramPreviewService.new(
          params[:program_type], 
          params[:cycle], 
          current_user
        ).call
      end
    end
  end
end
```

## Development Guidelines

### Code Organization
- **Models**: Business logic and relationships
- **Services**: Complex operations (substitution, progression, PDF generation)
- **ViewComponents**: Reusable UI components
- **Stimulus**: Client-side interactivity
- **Background Jobs**: Heavy operations (PDF generation, progress analysis)

### Testing Strategy
```ruby
# Use RSpec for comprehensive testing
# test/models/exercise_test.rb
# test/services/exercise_substitution_service_test.rb
# test/components/workout_card_component_test.rb
# test/system/workout_flow_test.rb
```

### Performance Considerations
- **Database indexing**: Optimize for equipment lookups and user queries
- **Caching**: Cache workout programs and exercise alternatives
- **Background jobs**: Handle PDF generation asynchronously
- **Lazy loading**: Load exercise details only when needed

## Migration Timeline
- **Weeks 1-2**: Foundation setup, data migration
- **Weeks 3-4**: User features, equipment management
- **Weeks 5-6**: Progress tracking and logging
- **Weeks 7-8**: Hotwire interactivity
- **Weeks 9-10**: PDF generation, mobile optimization
- **Weeks 11-12**: Advanced features, polish

## Success Metrics
- ✅ User can create account and select equipment
- ✅ Workouts automatically substitute exercises based on available equipment
- ✅ Progress tracking works seamlessly on mobile
- ✅ PDF generation matches original Next.js quality
- ✅ App feels responsive with Hotwire (no full page reloads)
- ✅ Workout logging is smooth and intuitive

This plan provides a solid foundation for pair programming sessions, with clear milestones and specific implementation details for each phase.