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

**✅ Sample Data Functional:**
- **7 core exercises** with working substitution logic: Back Squat, Goblet Squat, Bench Press, Deadlift, Overhead Press (OHP), Chin-ups, Ring Row
- Substitution system verified working with populated data

### Phase 3D: Complete Data Population 🔄 IN PROGRESS  
**🔧 DATA QUALITY ISSUE IDENTIFIED:**
Root cause of substitution problems: incorrect movement pattern assignments
- Example: OHP assigned "squat" pattern instead of "vertical_push"
- Most exercises incorrectly categorized, causing wrong substitutions

**📊 Data Population Workflow Ready:**
- `exercise_attributes_needed.csv` - Complete list of all 96 exercises
- `EXERCISE_ATTRIBUTE_SCHEMA.md` - Comprehensive schema for n8n workflow
- User can now populate all exercise attributes with correct movement patterns

**📋 Remaining Tasks:**
- User completes exercise attribute population via n8n workflow (all 96 exercises)
- Test substitution system with complete, corrected dataset
- Validate substitution accuracy across all movement patterns

**✅ BLOCKER RESOLVED**: JSONB query syntax fixed, system fully functional

## Data Management

### Seeding Data
- Uses `db/hardcoded_program_data.rb` (no YAML dependency)
- Contains 2 programs, 6 cycles, 21 sessions, 106 exercises
- Run `rails db:seed` to populate database

### Exercise Attribute Population
- **Script**: `script/populate_exercise_attributes.rb` 
- **Status**: 7/96 exercises have full substitution attributes
- **Populated Exercises**: Back Squat, Goblet Squat, Bench Press, Deadlift, Overhead Press (OHP), Chin-ups, Ring Row
- **Attributes**: `primary_muscles`, `equipment_required`, `training_effects`, `effectiveness_score`
- **Missing**: 89 exercises still need attribute population for full substitution functionality

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

### Helper Methods
- **Extract complex view logic** to helper methods in `app/helpers/`
- **Return data structures** ready for Rails form helpers (e.g., `options_for_select`)
- **Separate styling logic** into dedicated helper methods for CSS classes
- **Example**: `substitution_options(exercise, substitutes, original_name)` returns clean option arrays

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

## 🚨 **IMMEDIATE NEXT STEPS (When Resuming Development)**

### **✅ COMPLETED: JSONB Query Syntax Fixed**
The exercise substitution system is now **fully functional** with corrected PostgreSQL operators in `app/models/exercise.rb`:

```ruby
# ✅ FIXED CODE in find_substitutes method:
.where("primary_muscles ?| array[:muscles]", muscles: self.primary_muscles)
.where("training_effects ?| array[:effects]", effects: self.training_effects)
```

### **✅ COMPLETED: UI Integration & Testing Ready**
- **✅ UI Complete**: Equipment selector and substitution dropdowns integrated and visible
- **✅ Sample Data**: 7 exercises functional for testing substitution logic
- **✅ System Working**: JSONB queries fixed, substitutions working correctly

### **🔄 IN PROGRESS: Complete Data Population**
**Ready for user action:**
- `exercise_attributes_needed.csv` contains all 96 exercises with current attributes
- `EXERCISE_ATTRIBUTE_SCHEMA.md` provides complete schema for n8n workflow
- User needs to populate exercise attributes including corrected movement patterns

### **🎯 NEXT PRIORITY: Exercise Attribute Population**
1. **User Action Required**: Complete n8n workflow to populate all 96 exercise attributes
2. **Focus Areas**: Correct movement patterns (fix "squat" assignments), muscle groups, equipment
3. **Testing**: Verify substitution accuracy with complete dataset
4. **Validation**: Ensure logical substitutions across all movement patterns

### **📊 Current Status**
- **Architecture**: ✅ Complete and tested
- **UI**: ✅ Integrated and functional  
- **Core Logic**: ✅ Working with sample data
- **Data Quality**: 🔄 7/96 exercises complete, movement patterns need correction