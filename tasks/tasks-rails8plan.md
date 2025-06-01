## Relevant Files

- `Gemfile` — Add required gems (pg, tailwindcss-rails, view_component, hotwire-rails, prawn, etc.)
- `config/database.yml` — Configure PostgreSQL connection
- `db/schema.rb`, `db/migrate/*.rb` — Database schema and migrations for all models
- `app/models/*.rb` — All core models (User, Equipment, Exercise, etc.)
- `app/controllers/*.rb` — Controllers for authentication, equipment, workouts, logging, etc.
- `app/views/` — Views for all user-facing pages, using Hotwire and Tailwind
- `app/components/` — ViewComponents for reusable UI
- `app/services/` — Service objects (e.g., ProgressionService, ExerciseSubstitutionService, WorkoutPdfService)
- `app/javascript/controllers/` — Stimulus controllers for interactivity
- `test/models/*.rb`, `test/controllers/*.rb`, `test/system/*.rb` — Tests for models, controllers, and system flows
- `db/seeds.rb` — Seed data for initial setup
- `config/routes.rb` — Define all routes
- `config/environments/*.rb` — Environment-specific settings
- `app/assets/stylesheets/application.tailwind.css` — Tailwind CSS config
- `app/views/layouts/application.html.erb` — Main layout
- `app/views/shared/` — Shared partials (flash, navigation, etc.)

### Notes

- Use FactoryBot and Faker for test data.
- Use i18n for all user-facing text.
- Use Tailwind CSS for all styling.
- Use Hotwire (Turbo/Stimulus) for SPA-like interactivity.
- Use Prawn for PDF generation.
- Place tests alongside the code they test.
- Never commit real credentials or secrets.

---

## Tasks

- [ ] 1.0 Project Setup & Core Models
  - [ ] 1.1 Create new Rails 8 project with PostgreSQL
  - [ ] 1.2 Add and install required gems (tailwindcss-rails, view_component, hotwire-rails, prawn, etc.)
  - [ ] 1.3 Initialize Tailwind CSS
  - [ ] 1.4 Generate core models: Equipment, Exercise, MovementPattern, WorkoutProgram, WorkoutCycle, WorkoutSession, WorkoutExercise
  - [ ] 1.5 Create and run migrations
  - [ ] 1.6 Seed initial data (equipment, movement patterns, exercises)
- [ ] 2.0 Authentication & User Management
  - [ ] 2.1 Generate User model with authentication (Rails 8 built-in or Devise)
  - [ ] 2.2 Implement user registration, login, and session management
  - [ ] 2.3 Add associations: UserEquipment, UserWorkoutSession, ExerciseLog
  - [ ] 2.4 Add user profile page
- [ ] 3.0 Equipment & Exercise Management
  - [ ] 3.1 Implement Equipment management UI (select/deselect equipment)
  - [ ] 3.2 Add join model UserEquipment and associations
  - [ ] 3.3 Implement Exercise management UI (CRUD for admin, view for users)
  - [ ] 3.4 Add logic for equipment-based exercise alternatives
- [ ] 4.0 Workout Program & Session Logic
  - [ ] 4.1 Implement WorkoutProgram, WorkoutCycle, WorkoutSession models and associations
  - [ ] 4.2 Build UI for viewing and selecting workout programs
  - [ ] 4.3 Implement logic for personalizing workouts based on user equipment
  - [ ] 4.4 Add WorkoutSession show page with personalized exercises
- [ ] 5.0 Workout Logging & Progress Tracking
  - [ ] 5.1 Implement UserWorkoutSession and ExerciseLog models
  - [ ] 5.2 Build UI for logging sets, reps, weights, and notes
  - [ ] 5.3 Implement ProgressionService for AMRAP-based progression
  - [ ] 5.4 Add user progress tracking dashboard
- [ ] 6.0 UI/UX: Hotwire, ViewComponents, and Tailwind
  - [ ] 6.1 Use ViewComponent for reusable UI (equipment selector, workout card, etc.)
  - [ ] 6.2 Implement Hotwire (Turbo/Stimulus) for interactivity (logging, program selection, etc.)
  - [ ] 6.3 Style all pages with Tailwind CSS
  - [ ] 6.4 Ensure accessibility and responsive design
- [ ] 7.0 PDF Export & Mobile Optimization
  - [ ] 7.1 Implement WorkoutPdfService for PDF generation
  - [ ] 7.2 Add download PDF button to workout session pages
  - [ ] 7.3 Optimize UI for mobile devices using Tailwind responsive utilities
- [ ] 8.0 Testing, Error Handling, and Deployment
  - [ ] 8.1 Add model, controller, and system tests (use FactoryBot and Faker)
  - [ ] 8.2 Add error handling and flash messages
  - [ ] 8.3 Add authorization (Pundit or CanCanCan)
  - [ ] 8.4 Set up deployment (Render, Fly.io, or Heroku)
  - [ ] 8.5 Configure environment variables and secrets
  - [ ] 8.6 Run migrations and seed data on server
  - [ ] 8.7 Set up monitoring and backups 