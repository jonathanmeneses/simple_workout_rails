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

### Phase 0-2: Foundation & Authentication ✅ COMPLETE
- **Navigation System**: Turbo Frames for fast partial page updates
- **Authentication**: User registration/login with Rails 8 built-in auth
- **Database Models**: Complete workout program hierarchy (Program → Cycle → Session → Exercise)
- **UI**: Modern Tailwind CSS interface, responsive design

### Phase 3A: Exercise Substitution Engine ✅ COMPLETE
**Smart substitution system with JSONB optimization:**

**Key files:**
- `app/models/exercise.rb` - Enhanced with JSONB attributes and substitution logic
- `app/models/exercise_substitution.rb` - Self-referential substitution relationships
- Database: JSONB columns with GIN indexes for fast containment searches

**✅ Substitution Engine Features:**
- **JSONB Arrays**: `primary_muscles`, `equipment_required`, `training_effects`
- **Validation Whitelists**: Enforced attribute constraints
- **Smart Matching Algorithm**: Prioritizes movement pattern > muscles > training effects
- **Equipment Filtering**: User-based equipment availability
- **Performance Optimized**: GIN indexes for fast JSONB queries

### Phase 3B: Substitution UI Implementation ✅ COMPLETE
**Smart substitution interface with clean architecture:**

**Key files:**
- `app/helpers/programs_helper.rb` - Helper methods for substitution options and styling
- `app/javascript/controllers/form_controller.js` - Reusable Stimulus controller for auto-submit
- `app/views/programs/components/_exercise_substitution_dropdown.html.erb` - Pure Turbo Frame substitution UI
- `app/views/programs/components/_equipment_selector.html.erb` - Equipment filtering interface

**✅ UI Implementation Features:**
- **Pure Turbo Frames**: No custom JavaScript, leverages Rails conventions
- **Helper Methods**: Clean separation of logic from view templates
- **Reusable Stimulus**: `form_controller.js` with `autoSubmit()` for all forms
- **State Persistence**: Equipment and substitution selections maintained across navigation
- **Equipment Defaults**: No selection = all equipment available, explicit bodyweight-only option

### Phase 3C: Core Functionality ✅ COMPLETE
**✅ JSONB Query Syntax FIXED:**
Corrected PostgreSQL operators in `app/models/exercise.rb`:
```ruby
# FIXED: Proper PostgreSQL JSONB operators
.where("primary_muscles ?| array[:muscles]", muscles: self.primary_muscles)
.where("training_effects ?| array[:effects]", effects: self.training_effects)
```

**✅ UI Integration Complete:**
- Exercise substitution dropdowns integrated into program view
- Equipment selector functional and visible
- Sets/reps display enhanced with parsing from notes field
- State persistence across Turbo Frame navigation

**✅ Complete Data Functional:**
- **198/198 exercises (100%)** with working substitution logic and complete attributes
- Unified exercise database with comprehensive workout contexts
- All movement patterns correctly assigned and tested

### Phase 3D: Complete Data Population ✅ COMPLETE
**✅ DATA QUALITY ISSUES RESOLVED:**
- All movement pattern assignments corrected (OHP now "vertical_push", etc.)
- **198/198 exercises (100%)** now have complete JSONB attributes
- Unified exercise database with comprehensive workout contexts implemented

**✅ Data Population Completed:**
- `db/unified_exercise_database.json` - 198 exercises with full attributes
- `db/import_unified_exercise_database.rb` - Robust import system
- All exercise attributes populated including corrected movement patterns

**✅ Architecture Improvements:**
- **Service Object Pattern**: Moved substitution logic to `ExerciseSubstitutionService`
- **Clean Architecture**: Model handles data, Service handles business logic
- **Comprehensive Testing**: Added service and helper tests
- **Performance Optimized**: GIN indexes on JSONB fields working perfectly

## Data Management

### Seeding Data
- Uses `db/hardcoded_program_data.rb` (no YAML dependency)
- Contains 2 programs, 6 cycles, 21 sessions, 106 exercises
- Run `rails db:seed` to populate database

### Exercise Attribute Population
- **Primary Script**: `db/import_unified_exercise_database.rb`
- **Status**: 198/198 exercises have complete substitution attributes
- **Data Source**: `db/unified_exercise_database.json` - comprehensive exercise database
- **Attributes**: `primary_muscles`, `equipment_required`, `training_effects`, `effectiveness_score`, `complexity_level`, `instructions`, `benefits`
- **Architecture**: Service object pattern with `ExerciseSubstitutionService`

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

## Development Best Practices

### Service Objects
- **Extract complex business logic** to service objects in `app/services/`
- **Single responsibility**: Each service handles one specific domain operation
- **Easy testing**: Services can be tested in isolation with clear inputs/outputs
- **Example**: `ExerciseSubstitutionService.call(exercise, user_equipment: equipment)`

### Helper Methods
- **Extract view-specific logic** to helper methods in `app/helpers/`
- **Delegate to services**: Use services for business logic, format results for views
- **Return view-ready data**: Prepared for Rails form helpers (e.g., `options_for_select`)
- **Example**: `substitution_options(exercise, equipment)` uses service and formats for UI

### Stimulus Controllers
- **Create reusable controllers** for common behaviors (e.g., `form_controller.js`)
- **Use descriptive action names** that clearly indicate purpose (`autoSubmit` not `submit`)
- **Prefer Rails conventions** over custom JavaScript when possible
- **Target parent elements** to enable reuse across multiple forms

### Turbo Frames
- **Use pure Turbo Frames** instead of inline JavaScript for dynamic content
- **Maintain state** through hidden form fields across frame updates
- **Target specific frames** with `data: { turbo_frame: "frame_id" }`
- **Combine with Stimulus** only when necessary for user interactions

### JSONB Best Practices
- **Use JSONB over JSON** for PostgreSQL performance benefits
- **Add GIN indexes** for fast containment searches (`?|`, `&&` operators)
- **Set default values** to empty arrays (`default: []`)
- **Validate with whitelists** using model constants and custom validations

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

## 🎉 **PHASE 3 COMPLETE - PRODUCTION READY SUBSTITUTION SYSTEM**

### **✅ COMPLETED: Full Implementation**
The exercise substitution system is **fully functional and production-ready**:

**🏗️ Service Object Architecture:**
```ruby
# Clean separation of concerns:
ExerciseSubstitutionService.call(exercise, user_equipment: equipment)
# Model delegates to service:
exercise.find_substitutes(equipment) 
```

### **✅ COMPLETED: Data & Performance**
- **✅ Complete Dataset**: 198/198 exercises with full attributes
- **✅ Performance Optimized**: GIN indexes on JSONB fields
- **✅ Smart Substitution**: Movement pattern prioritization with cross-pattern fallbacks
- **✅ Equipment Filtering**: User equipment constraints working

### **✅ COMPLETED: Architecture & Testing**
- **✅ Service Pattern**: `ExerciseSubstitutionService` handles complex logic
- **✅ Clean Models**: Exercise model focused on data relationships
- **✅ Helper Methods**: UI formatting separated from business logic
- **✅ Comprehensive Tests**: Service and helper test coverage

### **🎯 NEXT PHASE: User Features & Enhancement**
**Ready for Phase 4 development:**
1. **User Equipment Profiles**: Persistent equipment selection
2. **Workout Logging**: Track completed workouts and progress
3. **Program Personalization**: User-specific program modifications
4. **Performance Monitoring**: Analytics and usage tracking

### **📊 Current Status: Phase 3 Complete**
- **Architecture**: ✅ Production-ready service pattern
- **UI**: ✅ Integrated and functional
- **Data Quality**: ✅ 198/198 exercises complete
- **Performance**: ✅ Optimized with proper indexing
- **Testing**: ✅ Comprehensive test coverage