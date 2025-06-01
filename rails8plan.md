# Rails 8 Workout Tracker Implementation Plan (Comprehensive)

## Overview
This plan combines a step-by-step beginner approach with advanced best practices and code samples. Each phase starts with a simple checklist, followed by advanced/optional details. You can follow just the checklists, or dive deeper into the advanced sections as you gain confidence.

---

## Phase 1: Project Setup & Core Models (Weeks 1-2)

### ✅ Beginner Checklist
1. **Create your Rails project**
   ```bash
   rails new workout_tracker_rails --database=postgresql
   cd workout_tracker_rails
   ```
2. **Add useful gems**
   ```bash
   bundle add tailwindcss-rails view_component hotwire-rails
   ```
3. **Initialize Tailwind CSS**
   ```bash
   rails tailwindcss:install
   ```
4. **Generate core models**
   ```bash
   rails generate model Equipment name:string
   rails generate model Exercise name:string movement_pattern:references exercise_type:integer
   rails generate model MovementPattern name:string
   rails generate model WorkoutProgram name:string program_type:integer
   rails generate model WorkoutCycle name:string cycle_type:integer workout_program:references
   rails generate model WorkoutSession name:string workout_cycle:references
   rails generate model WorkoutExercise workout_session:references exercise:references sets:integer reps:integer notes:string order_position:integer
   rails db:migrate
   ```
5. **Seed initial data**
   - Edit `db/seeds.rb` to add some equipment, movement patterns, and exercises.
   - Run:
     ```bash
     rails db:seed
     ```

---

### 💡 Advanced/Best Practices
- **Model Relationships**
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
  end
  # ...repeat for other models
  ```
- **Data Migration**
  - If you have existing data (e.g., from a TypeScript app), write a script or use `db/seeds.rb` to import it.
- **Component Architecture**
  - Consider using [ViewComponent](https://viewcomponent.org/) for reusable UI pieces.
- **Hotwire**
  - Rails 8 comes with Turbo/Stimulus for SPA-like navigation without much JS.

---

## Phase 2: Authentication & Basic UI (Weeks 3-4)

### ✅ Beginner Checklist
1. **Add authentication**
   ```bash
   rails generate authentication User
   rails db:migrate
   ```
   - This gives you user sign up, login, and session management.
2. **Scaffold simple UI**
   ```bash
   rails generate scaffold_controller Equipment
   rails generate scaffold_controller Exercise
   # ...repeat for other models as needed
   ```
   - Use Hotwire (Turbo/Stimulus) for SPA-like navigation (comes with Rails 8).
3. **Set up home page and navigation**
   - In `config/routes.rb`:
     ```ruby
     root 'workout_programs#index'
     ```
   - Add navigation links for users to view programs, log in, etc.

---

### 💡 Advanced/Best Practices
- **User Model Associations**
  ```ruby
  # app/models/user.rb
  class User < ApplicationRecord
    has_many :user_equipment
    has_many :equipment, through: :user_equipment
    has_many :user_workout_sessions
    has_many :exercise_logs, through: :user_workout_sessions
  end
  ```
- **Equipment Management UI**
  - Use ViewComponent for an equipment selector.
  - Use Turbo Frames for updating equipment without full page reloads.
- **Navigation**
  - Use partials or ViewComponents for navigation bars.
- **Authentication Customization**
  - Customize Devise or Rails Auth views for branding and UX.
- **Hotwire**
  - Use Turbo Streams for real-time updates (e.g., when a user adds/removes equipment).

---

## Phase 3: User Features & Equipment Management (Weeks 5-6)

### ✅ Beginner Checklist
1. **Add a join model for user equipment**
   ```bash
   rails generate model UserEquipment user:references equipment:references
   rails db:migrate
   ```
2. **Add associations**
   - Update `user.rb` and `equipment.rb` to add associations for user equipment.
3. **Build a simple UI for users to select their available equipment**
   - Add a form or checkboxes to let users pick their equipment.

---

### 💡 Advanced/Best Practices
- **Join Model Example**
  ```ruby
  # app/models/user_equipment.rb
  class UserEquipment < ApplicationRecord
    belongs_to :user
    belongs_to :equipment
  end
  ```
- **Personalized Equipment Selector**
  - Use ViewComponent for a reusable equipment selector UI.
  - Use Turbo Frames for instant updates when users select/deselect equipment.
- **User Personalization**
  - Add a method to `User` to return available equipment IDs for filtering workouts.

---

## Phase 4: Workout Personalization & Logging (Weeks 7-8)

### ✅ Beginner Checklist
1. **Personalize workouts based on user equipment**
   - In your controller/views, filter exercises based on user equipment.
   - Start simple: just show/hide exercises the user can't do.
2. **Add workout logging models**
   ```bash
   rails generate model UserWorkoutSession user:references workout_session:references status:integer
   rails generate model ExerciseLog user_workout_session:references exercise:references workout_exercise:references weight:float sets_completed:integer reps_completed:integer rpe:integer notes:string
   rails db:migrate
   ```
3. **Build logging UI**
   - Let users mark workouts as started/completed.
   - Let users log sets, reps, and weights for each exercise.

---

### 💡 Advanced/Best Practices
- **Personalization Logic**
  - Add a method to `WorkoutSession` or a service object to return only exercises the user can do with their equipment.
- **Workout Logging Models**
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
  end
  ```
- **Hotwire for Logging**
  - Use Turbo Frames and Stimulus controllers for auto-saving workout logs.
- **Progression Logic**
  - Add a service for AMRAP-based progression (e.g., +5lb if AMRAP ≥5 reps).

---

## Phase 5: Polish, Error Handling, and Testing (Weeks 9-10)

### ✅ Beginner Checklist
1. **Add error handling**
   - Use Rails flash messages for errors and notices.
   - Add basic validations to your models (e.g., presence, numericality).
2. **Add authorization**
   - Use [Pundit](https://github.com/varvet/pundit) or [CanCanCan](https://github.com/CanCanCommunity/cancancan) to restrict access to user data.
3. **Add testing**
   - Use RSpec for model and controller tests.
   - Use system tests (Capybara) for end-to-end flows.
4. **Debugging setup**
   - Install the Ruby extension in VSCode.
   - Add `.vscode/launch.json` for debugging:
     ```json
     {
       "version": "0.2.0",
       "configurations": [
         {
           "name": "Rails server (debug)",
           "type": "Ruby",
           "request": "launch",
           "program": "${workspaceRoot}/bin/rails",
           "args": ["server"],
           "useBundler": true,
           "env": {
             "RUBY_DEBUG_OPEN": "true"
           }
         }
       ]
     }
     ```
   - Set breakpoints and use F5 to debug.

---

### 💡 Advanced/Best Practices
- **Model Validations**
  - Add presence, numericality, and custom validations to all models.
- **Authorization**
  - Use Pundit/CanCanCan policies for all sensitive actions.
- **Testing**
  - Use FactoryBot for test data.
  - Add system tests for user flows (sign up, log workout, etc.).
- **Error Monitoring**
  - Integrate with Sentry or Rollbar for production error tracking.

---

## Phase 6: PDF Export & Mobile Optimization (Weeks 11-12)

### ✅ Beginner Checklist
1. **PDF export**
   - Use [Prawn](https://github.com/prawnpdf/prawn) for PDF generation.
   - Start with a simple PDF (workout title, exercises, sets/reps).
   - Add download links to workout pages.
2. **Mobile-first design**
   - Use Tailwind CSS responsive utilities to make your UI mobile-friendly.
   - Test on your phone or browser dev tools.

---

### 💡 Advanced/Best Practices
- **PDF Generation Service**
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
        # ...
      end
    end
  end
  ```
- **Mobile Optimization**
  - Use Tailwind's responsive classes (`px-2 sm:px-4 md:px-8`).
  - Test with Chrome DevTools device emulation.

---

## (Optional) Phase 7: API/Hybrid Mode

### ✅ Beginner Checklist
1. **Add API endpoints (optional/advanced)**
   - Use Rails generators to scaffold API controllers:
     ```bash
     rails generate controller api/v1/workouts
     ```
   - Respond with JSON for workouts, logging, etc.
2. **(Optional) Build a React/Vue/Next.js frontend or mobile app**
   - Use your API endpoints to power a modern frontend or mobile app.

---

### 💡 Advanced/Best Practices
- **API Versioning**
  - Namespace your API controllers (`api/v1/...`).
- **Authentication**
  - Use JWT or session-based auth for API endpoints.
- **Background Jobs**
  - Use Sidekiq or Solid Queue for heavy tasks (PDF generation, analytics).

---

## Deployment

### ✅ Beginner Checklist
1. **Deploy to a platform**
   - Use [Render](https://render.com/), [Fly.io](https://fly.io/), or [Heroku](https://heroku.com/).
2. **Set up environment variables and secrets**
3. **Run migrations and seed data on your server**
   ```bash
   rails db:migrate
   rails db:seed
   ```

---

### 💡 Advanced/Best Practices
- **CI/CD**
  - Set up GitHub Actions or similar for automated tests and deploys.
- **Monitoring**
  - Use Skylight, New Relic, or similar for performance monitoring.
- **Backups**
  - Schedule regular database backups.

---

## Success Metrics
- ✅ User can sign up, log in, and select equipment
- ✅ Workouts are personalized based on equipment
- ✅ Users can log workouts and track progress
- ✅ PDF export works
- ✅ App is mobile-friendly
- ✅ Tests pass and errors are handled

---

## Tips for Beginners
- Start simple: get the basic Rails app working before adding advanced features.
- Use Rails generators to scaffold code and learn the conventions.
- Ask for help or look up docs when you get stuck—Rails has a great community!
- Commit and push your code often.

---

This plan is now comprehensive and step-by-step. You can always add more advanced features (API, React, background jobs, etc.) once you're comfortable with Rails basics!
