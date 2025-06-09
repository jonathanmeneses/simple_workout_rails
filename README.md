# Simple Workout Tracking - Rails 8

A modern Rails 8 workout tracking application with intelligent exercise substitution and equipment-based program customization. Built with Hotwire (Turbo/Stimulus) for SPA-like interactions without heavy JavaScript.

## Features

- **Workout Program Generator**: Database-backed workout programs with cycles, sessions, and exercises
- **Smart Exercise Substitution**: JSONB-optimized substitution engine with movement pattern matching
- **Equipment Filtering**: Dynamic program customization based on available equipment
- **Modern UI**: Responsive Tailwind CSS interface with Turbo Frames for fast navigation
- **User Authentication**: Rails 8 built-in authentication with session management

## Quick Start

### Prerequisites
- Ruby 3.1+
- PostgreSQL 14+
- Node.js 18+ (for asset compilation)

### Setup
```bash
# Clone and setup
git clone <repository-url>
cd simple_workout_tracking
bundle install

# Database setup
rails db:create
rails db:migrate
rails db:seed

# Start server
rails server -p 3001
```

Visit `http://localhost:3001` to access the application.

## Architecture

### Database Models Hierarchy
```
WorkoutProgram (full_body_3_day, upper_lower_4_day)
├── WorkoutCycle (Base Strength, Unilateral & Core, Power & Plyometrics)
    └── WorkoutSession (individual workout days)
        └── WorkoutExercise (exercises with sets/reps/notes)
            └── Exercise (belongs_to movement_pattern)
```

### Technology Stack
- **Backend**: Rails 8 with PostgreSQL
- **Frontend**: Hotwire (Turbo Frames/Stimulus), Tailwind CSS
- **Authentication**: Rails 8 built-in authentication
- **Database**: PostgreSQL with JSONB optimization
- **Testing**: Minitest with system tests

## Development

### Essential Commands
```bash
# Development server
rails server -p 3001

# Database operations
rails db:migrate
rails db:seed
rails db:reset  # Drop, create, migrate, seed

# Testing
rails test                    # All tests
rails test:system            # System tests
rails test test/models/      # Model tests

# Code quality
bundle exec rubocop          # Ruby style guide
bundle exec brakeman         # Security scanning

# Console access
rails console
```

### Project Structure
- `app/models/` - Core domain models with JSONB attributes
- `app/controllers/` - RESTful controllers with Turbo support
- `app/helpers/` - View logic helpers (substitution options, styling)
- `app/javascript/controllers/` - Stimulus controllers for interactions
- `app/views/programs/components/` - Reusable view components
- `db/hardcoded_program_data.rb` - Seeded workout program data

## Current Implementation Status

### ✅ Completed Features
- **Phase 0-2**: Foundation, UI, and authentication system
- **Phase 3A-3C**: Exercise substitution engine with JSONB optimization
  - Smart substitution algorithm with movement pattern prioritization
  - Equipment-based filtering with "No equipment" and "All Equipment" options
  - Pure Turbo Frame UI with helper methods and reusable Stimulus controllers
  - JSONB arrays with GIN indexes for fast containment searches

### 🔄 In Progress
- **Phase 3D**: Complete exercise attribute population
  - **Current**: 7/96 exercises fully populated (Back Squat, Goblet Squat, Bench Press, Deadlift, OHP, Chin-ups, Ring Row)
  - **Target**: 96/96 exercises with correct movement patterns and substitution attributes

### Exercise Substitution System
The app features an intelligent substitution engine that:
- Matches exercises by movement pattern, muscle groups, and training effects
- Filters options based on user's available equipment
- Prioritizes main lifts over accessory exercises
- Uses JSONB attributes for fast PostgreSQL queries

**Available Programs:**
- **3-Day Full Body**: Complete body workout 3x per week
- **4-Day Upper/Lower**: Upper/lower body split 4x per week

## Data Management

### Exercise Attributes
Each exercise includes JSONB attributes for smart substitution:
- `primary_muscles`: Target muscle groups
- `equipment_required`: Required equipment list
- `training_effects`: Strength, hypertrophy, power, endurance
- `effectiveness_score`: Relative exercise effectiveness (1-10)

### Seeded Data
- 2 workout programs with 6 cycles, 21 sessions, 106 exercises
- Equipment database with bodyweight, barbell, dumbbell, and specialized equipment
- Movement patterns: squat, hinge, horizontal_push, horizontal_pull, vertical_push, vertical_pull, carry, core

## Testing

The project uses Minitest with comprehensive test coverage:
- **Model tests**: Validations, associations, and business logic
- **Controller tests**: Request handling and Turbo responses
- **System tests**: End-to-end user workflows with Capybara
- **Integration tests**: Multi-controller user flows

```bash
# Run specific test types
rails test test/models/exercise_test.rb
rails test test/controllers/programs_controller_test.rb
rails test test/system/program_navigation_test.rb
```

## Contributing

1. Follow Rails conventions and existing code patterns
2. Use helper methods for complex view logic
3. Prefer Turbo Frames over custom JavaScript
4. Add tests for new functionality
5. Run `bundle exec rubocop` before committing

## Deployment

Configured for deployment with:
- Docker containerization
- Kamal deployment tool
- PostgreSQL database
- Rails 8 Solid Cache, Queue, and Cable

## License

This project is available as open source under the terms of the MIT License.