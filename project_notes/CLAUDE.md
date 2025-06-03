# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rails 8 workout tracking application with a workout program generator interface. Features database-backed workout programs with cycles, sessions, and exercises. Uses Hotwire (Turbo/Stimulus) for SPA-like interactions without heavy JavaScript.

## Development Commands

### Server and Database
```bash
# Start development server
rails server -p 3001

# Database operations
rails db:migrate
rails db:seed
rails db:reset  # Drop, create, migrate, seed

# Console access
rails console
```

### Testing
```bash
# Run all tests (uses Minitest, not RSpec)
rails test

# Run specific test files
rails test test/models/user_test.rb
rails test test/controllers/programs_controller_test.rb

# Run system tests
rails test:system
```

### Code Quality
```bash
# Linting (Ruby style guide)
bundle exec rubocop

# Security scanning
bundle exec brakeman
```

## Architecture Overview

### Database Models Hierarchy
```
WorkoutProgram (2 types: full_body_3_day, upper_lower_4_day)
├── WorkoutCycle (Base Strength, Unilateral & Core, Power & Plyometrics)
    └── WorkoutSession (individual workout days)
        └── WorkoutExercise (exercises with sets/reps/notes)
            └── Exercise (belongs_to movement_pattern)
```

### Key Model Relationships
- `WorkoutProgram` → `WorkoutCycle` → `WorkoutSession` → `WorkoutExercise` → `Exercise`
- User authentication via `User` model with `has_secure_password`
- Session management through `Session` model

### Frontend Architecture
- **Hotwire/Turbo**: SPA-like navigation without heavy JavaScript
- **Stimulus Controllers**: `programs_controller.js` handles view mode switching with simple navigation
- **Navigation**: Uses `window.location.href` for reliable page updates
- **Tailwind CSS**: Utility-first styling

## Current Implementation Status

### Navigation System: WORKING ✅
All view mode buttons (Description/Program/Schedule) work correctly using simple `window.location.href` navigation.

**Key files:**
- `app/views/programs/show.html.erb` - Main program display with working view mode tabs
- `app/javascript/controllers/programs_controller.js` - Simple navigation handlers
- `app/controllers/programs_controller.rb` - Handles view_mode and cycle parameters

**Future optimization opportunity:**
- Consider Turbo Frames for partial updates instead of `window.location.href`
- Would eliminate JavaScript and provide better UX with partial page updates

## Data Management

### Seeding Data
- Uses `db/hardcoded_program_data.rb` (no YAML dependency)
- Contains 2 programs, 6 cycles, 21 sessions, 106 exercises
- Run `rails db:seed` to populate database

### Test Data
- Located in `test/fixtures/*.yml`
- Uses Rails fixtures, not FactoryBot

## File Organization

### Controllers
- `ProgramsController` - Main workout program interface
- `UsersController` - User registration  
- `SessionsController` - Authentication
- `PasswordsController` - Password reset

### Views
- `programs/` - Main program display with Turbo Stream support
- `programs/components/` - Reusable view partials
- Uses `.html.erb` and `.turbo_stream.erb` formats

### JavaScript
- Stimulus controllers in `app/javascript/controllers/`
- No heavy JavaScript framework - relies on Hotwire

## Testing Strategy

- **Minitest** (not RSpec) - removed RSpec completely
- System tests use Capybara + Selenium
- Test coverage with SimpleCov
- Model tests focus on validations and associations
- Integration tests for key user flows

## Deployment

- Configured for Docker deployment with Kamal
- Uses PostgreSQL database
- Server runs on port 3001 in development
- Solid Cache, Solid Queue, Solid Cable for Rails 8 features