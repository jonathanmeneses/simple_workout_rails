# PRD-03: Equipment Data Migration & Relational Refactor

**Status:** Planning Phase  
**Priority:** High (Blocks future development)  
**Estimated Effort:** 2-3 weeks  
**Dependencies:** Current JSONB equipment system  

## Problem Statement

The current equipment system has significant data quality issues that block reliable exercise substitution:

### Current Issues
- **Dual Data Systems**: Equipment table exists but JSONB arrays are used for logic
- **Data Inconsistencies**: Equipment names don't match between table and JSONB usage
- **Hardcoded Dependencies**: UI relies on `Exercise::VALID_EQUIPMENT` constant
- **Maintenance Overhead**: Adding equipment requires code changes, not just data

### Data Inconsistency Examples
```
JSONB Equipment Usage: ["cable_machine", "dumbbells", "resistance_bands", "safety_bar", "squat_rack"]
Equipment Table Missing: cable_machine, dumbbells, resistance_bands, safety_bar, squat_rack

Equipment Table Unused: ["rack", "dumbbell", "heel_wedge", "bodyweight", "TRX_or_rail"]
```

## Solution Overview

Migrate from JSONB equipment arrays to proper relational database design using existing `exercise_equipments` join table.

### Key Benefits
- **Clean relational data** with proper foreign key constraints
- **Database-driven equipment management** (no code changes for new equipment)
- **Consistent equipment naming** across all systems
- **Better query performance** with proper indexes
- **Maintainable codebase** without hardcoded equipment lists

## Technical Implementation Plan

### Phase 1: Foundation Setup
1. **Create ExerciseEquipment model**
2. **Enhance Equipment model** with title, description fields
3. **Update Exercise model** with proper associations

### Phase 2: Data Standardization
4. **Manual equipment cleanup** (user task - see User Manual below)
5. **Populate enhanced equipment records**

### Phase 3: Migration Execution
6. **Create data migration script** (JSONB → relational)
7. **Update substitution logic** to use joins instead of JSONB queries
8. **Update auto-substitution methods**

### Phase 4: UI & Logic Updates
9. **Refactor equipment selector** to use Equipment.all
10. **Update ProgramsController** equipment handling
11. **Add equipment management interface**

### Phase 5: Cleanup & Optimization
12. **Remove JSONB equipment code** and columns
13. **Update comprehensive test suite**
14. **Performance optimization** with proper indexes

## Acceptance Criteria

### Functional Requirements
- [ ] All exercises use relational equipment associations
- [ ] Equipment selector populated from database, not constants  
- [ ] Exercise substitution works with relational equipment data
- [ ] Auto-substitution logic uses equipment associations
- [ ] Equipment management interface for adding new equipment

### Data Quality Requirements
- [ ] Zero equipment naming inconsistencies
- [ ] All equipment has title, description
- [ ] All exercises have proper equipment associations
- [ ] No orphaned equipment or exercise records

### Performance Requirements
- [ ] Equipment queries perform as well or better than JSONB
- [ ] Proper database indexes on equipment associations
- [ ] No N+1 queries in equipment-related views

## Risk Assessment

### Technical Risks
- **Data migration complexity**: 198 exercises with equipment data
- **Query performance**: Ensuring joins perform well vs JSONB containment
- **Breaking changes**: Equipment-related features during migration

### Mitigation Strategies
- **Comprehensive backup** before any data migration
- **Staged migration** with rollback capability
- **Thorough testing** of all equipment-dependent features
- **Performance benchmarking** before/after migration

## Success Metrics

### Before Migration
- Equipment data inconsistencies: **11 naming conflicts**
- Equipment management: **Code changes required**
- Query complexity: **JSONB containment operators**

### After Migration
- Equipment data consistency: **100%**
- Equipment management: **Database-driven**
- Query simplicity: **Standard SQL joins**

## Dependencies

### Technical Dependencies
- Existing `equipment` and `exercise_equipments` tables
- Rails association framework
- Current substitution logic architecture

### User Dependencies
- **Manual equipment cleanup** (detailed in User Manual)
- **Equipment data validation** and verification
- **UI testing** after equipment selector changes

---

# User Manual: Equipment Data Cleanup

*Use this section as a prompt for manual equipment standardization work*

## Equipment Cleanup Task

You are helping clean up equipment data for a Rails workout tracking application. The system currently has inconsistent equipment naming between the database table and JSONB usage in exercises.

### Getting the Current Data

First, run this command to extract the current equipment data:

```bash
rails runner "
puts '=== EQUIPMENT TABLE ==='
Equipment.pluck(:name).sort.each { |name| puts '- ' + name }

puts
puts '=== JSONB EQUIPMENT USAGE ==='
jsonb_equipment = Exercise.where.not(equipment_required: [])
                          .pluck(:equipment_required)
                          .flatten.uniq.sort
jsonb_equipment.each { |name| puts '- ' + name }

puts
puts '=== DATA INCONSISTENCIES ==='
db_equipment = Equipment.pluck(:name)
puts 'In JSONB but missing from Equipment table:'
(jsonb_equipment - db_equipment).each { |name| puts '  + ' + name }
puts 'In Equipment table but not used in JSONB:'
(db_equipment - jsonb_equipment).each { |name| puts '  - ' + name }

puts
puts '=== EXAMPLE EXERCISE EQUIPMENT ==='
Exercise.where.not(equipment_required: []).limit(10).each do |ex|
  puts ex.name + ': ' + ex.equipment_required.to_s
end
"
```

Copy this output and use it as the basis for your cleanup decisions below.
```
OUTPUT:
=== EQUIPMENT TABLE ===
- TRX_or_rail
- adjustable_bench
- barbell
- bench
- bodyweight
- dip_bars
- dumbbell
- heel_wedge
- kettlebell
- landmine
- medicine_ball
- plate
- pull_up_bar
- rack
- rings
- rings_or_TRX
- trap_bar

=== JSONB EQUIPMENT USAGE ===
- barbell
- bench
- cable_machine
- dumbbells
- kettlebell
- medicine_ball
- pull_up_bar
- resistance_bands
- safety_bar
- squat_rack
- trap_bar

=== DATA INCONSISTENCIES ===
In JSONB but missing from Equipment table:
  + cable_machine
  + dumbbells
  + resistance_bands
  + safety_bar
  + squat_rack
In Equipment table but not used in JSONB:
  - rack
  - dumbbell
  - heel_wedge
  - bodyweight
  - TRX_or_rail
  - adjustable_bench
  - dip_bars
  - rings
  - landmine
  - plate
  - rings_or_TRX

=== EXAMPLE EXERCISE EQUIPMENT ===
Conventional Deadlift: ["barbell"]
Deadlift: ["barbell"]
Back Squat: ["barbell", "squat_rack"]
Bench Press: ["barbell", "bench"]
Chin-ups: ["pull_up_bar"]
Clean and Jerk: ["barbell"]
Hip Thrust: ["barbell", "bench"]
Overhead Press: ["barbell"]
Overhead Press (OHP): ["barbell"]
Power Clean: ["barbell"]
```

### Current Data State

**Equipment Table (17 records):**
`barbell`, `rack`, `kettlebell`, `dumbbell`, `heel_wedge`, `bodyweight`, `TRX_or_rail`, `trap_bar`, `bench`, `adjustable_bench`, `pull_up_bar`, `dip_bars`, `rings`, `landmine`, `plate`, `rings_or_TRX`, `medicine_ball`

**JSONB Usage in Exercises (11 unique values):**
`barbell`, `bench`, `cable_machine`, `dumbbells`, `kettlebell`, `medicine_ball`, `pull_up_bar`, `resistance_bands`, `safety_bar`, `squat_rack`, `trap_bar`

### Your Tasks

#### Task 1: Resolve Naming Conflicts
Choose the final naming for these conflicts:
- `dumbbell` (table) vs `dumbbells` (JSONB)
- `rack` (table) vs `squat_rack` (JSONB)  
- Should `safety_bar` be separate from `barbell`?

#### Task 2: Add Missing Equipment
Create records for equipment used in JSONB but missing from table:
- `cable_machine`
- `resistance_bands` 
- `safety_bar`
- `squat_rack` (if keeping separate)

#### Task 3: Equipment Enhancement
For ALL equipment, provide title and description:

#### Task 4: Unused Equipment Review
Decide keep/remove for unused equipment:
- `heel_wedge` - Keep or remove?
- `bodyweight` - Should this be equipment or special case?
- `TRX_or_rail` - Keep as one item or split?
- `adjustable_bench` vs `bench` - Need both?
- `rings_or_TRX` vs `rings` - Redundant?
- `plate` - Standalone equipment or accessory?

### Deliverable Format

Provide a YAML structure like this:

```yaml
# FINAL EQUIPMENT LIST
equipment:
  - name: "barbell"
    title: "Olympic Barbell"
    description: "45lb Olympic barbell for heavy compound movements"
    
  - name: "squat_rack"
    title: "Squat Rack"  
    description: "Power rack or squat stand for safe barbell movements"
    
  - name: "cable_machine"
    title: "Cable Machine"
    description: "Adjustable cable machine for various pulling and pressing movements"
    
  # Continue for all equipment...

# EQUIPMENT TO REMOVE (if any)
removed:
  - name: "heel_wedge"
    reason: "Rarely used, specialized equipment"
    
# NAMING STANDARDIZATION
renamed:
  - old: "dumbbell"
    new: "dumbbells"
    reason: "Match JSONB usage pattern"
```

### Guidelines

1. **Consistency First**: Choose naming that will be consistent across all systems
2. **User-Friendly Titles**: Titles should be clear to end users
3. **Clear Descriptions**: Descriptions should help users understand what the equipment is
4. **Equipment Reality**: Only include equipment that's commonly available
5. **Future-Proof**: Consider what equipment might be added later

### Validation Questions

Before finalizing, consider:
- Do all exercise equipment requirements make sense?
- Are equipment categories logical for UI grouping?
- Will equipment names work well in URLs and forms?
- Are titles clear for non-expert users?
- Do descriptions help users understand equipment needs?

This cleanup will create a clean, maintainable equipment system that supports future growth and eliminates current data inconsistencies.