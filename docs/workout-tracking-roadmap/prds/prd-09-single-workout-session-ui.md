# PRD-09: Single Workout Session UI Restructure

## Overview
Transform the program view from a full program overview to a focused single workout session experience with improved navigation, cleaner state management, and workout day tabs.

## Background & Motivation
Current program view shows entire cycles with all workout sessions at once, creating cognitive overload. Users want to focus on "today's workout" rather than browse the entire program. The UI should match the mental model: select a cycle, pick a workout day, see that specific session.

**Current Foundation Status (2025-01-06):**
- ✅ Exercise substitution engine fully functional with 223 complete exercises
- ✅ Equipment system standardized with 22 equipment types
- ✅ Solid data foundation ready for improved UI architecture

Current workflow friction:
- Users must scroll through multiple workout sessions to find today's workout
- Equipment changes affect entire program view (heavy page renders)
- Cycle selection buried in forms rather than prominent UI
- Schedule tab provides little value compared to focused workout view

## Goals
1. **Single workout focus** - Show one workout session at a time
2. **Intuitive navigation** - Clear cycle → workout day → session flow  
3. **Prominent workout day selection** - Tabs for FB-A, FB-B, FB-C, etc.
4. **Cleaner state management** - ID-based URLs, better Turbo Frame boundaries
5. **Collapsible equipment** - Hide complexity when not needed

## User Stories

### As a user planning today's workout
- I want to select my training cycle and immediately see workout day options
- I want to click "FB-A" and see just that workout, not everything
- I want equipment changes to only affect the current workout view
- I want the URL to remember my specific workout selection

### As a user exploring a program
- I want to easily switch between workout days (FB-A → FB-B → FB-C)
- I want cycle selection to be prominent, not buried in a form
- I want equipment customization available but not cluttering the main view

## Current Structure vs. New Structure

### Current Structure (Problems)
```
Tabs: [Description] [Program] [Schedule]

Program Tab:
├── Equipment Selector (always visible)
├── Cycle Selector (form dropdown)
└── All Workout Sessions (FB-A, FB-B, FB-C all at once)
    ├── FB-A: Squat & Press Variation (full exercise list)
    ├── FB-B: Power/DL (full exercise list)  
    └── FB-C: Squat & Press Variation (full exercise list)
```

### New Structure (Solution)
```
Tabs: [Description] [Program]

Program Tab:
├── Workout Settings Section
│   ├── Cycle Selection Dropdown (prominent)
│   ├── View Mode Dropdown (Single Session | Full Program)
│   └── [Collapsible] Equipment Customization
├── Workout Day Tabs: [FB-A] [FB-B] [FB-C]
└── Single Workout Session View
    ├── Exercise cards for selected session only
    ├── Cycle context: "Cycle 1 - Week 1"
    └── Next workout preview
```

## Functional Requirements

### 1. Remove Schedule Tab
- **Current**: Description | Program | Schedule  
- **New**: Description | Program
- **Rationale**: Schedule view provides minimal value vs. focused workout selection

### 2. Redesign Program Tab Structure

#### Workout Settings Section
```
┌─────────────────────────────────────────────────┐
│ Workout Settings                                │
│ Customize your workout program and view options │
│                                                 │
│ Training Cycle    View Mode         [Customize] │
│ [Base Strength ▼] [Single Session ▼] Equipment  │
└─────────────────────────────────────────────────┘
```

- **Training Cycle**: Prominent dropdown (Base Strength, Unilateral & Core, etc.)
- **View Mode**: 
  - "Single Workout Session" (new default)
  - "Full 12-Week Program" (current program view for reference)
- **Equipment**: Collapsible section, hidden by default

#### Workout Day Tabs
```
┌─────────────────────────────────────────────────┐
│ 🏋️ Main Lifts    🔄 Accessory Exercises        │
├─────────────────────────────────────────────────┤
│ [FB-A (Squat)] [FB-B (Power/DL)] [FB-C (Variation)] │
└─────────────────────────────────────────────────┘
```

- Dynamic tabs based on selected cycle's workout sessions
- Clear session identification (FB-A, FB-B, FB-C)
- Active tab highlights current selection
- Turbo Frame targets for fast switching

#### Single Workout Session View
```
┌─────────────────────────────────────────────────┐
│ FB-C: Squat & Press Variation                   │
│ Cycle 1 - Week 1                    👁️ Preview │
├─────────────────────────────────────────────────┤
│ [Exercise Card 1: Back Squat]                   │
│ [Exercise Card 2: Bench Press]                  │  
│ [Exercise Card 3: Chin-ups]                     │
├─────────────────────────────────────────────────┤
│ Next Workout: FB-A (Squat)                     │
└─────────────────────────────────────────────────┘
```

- Show only selected workout session
- Display cycle/week context
- Exercise cards with substitution capabilities
- Next workout preview for planning

### 3. URL Structure Migration

#### Current (Name-Based)
```
/programs/1?view_mode=program&cycle=Base+Strength
```
**Problems**: 
- Text matching slower than ID lookup
- Breaks if cycle names change
- No session selection
- URL encoding issues

#### New (ID-Based)
```
/programs/1?view_mode=program&cycle_id=2&session_id=5
```
**Benefits**:
- Faster database queries (primary key lookup)
- Reliable (IDs don't change)
- Session-specific URLs
- Cleaner implementation

### 4. State Management Improvements

#### Controller Changes
```ruby
# Current
@selected_cycle = @program.workout_cycles.find_by(name: params[:cycle])

# New  
@selected_cycle = @program.workout_cycles.find(params[:cycle_id]) if params[:cycle_id].present?
@selected_cycle ||= @program.workout_cycles.first

@selected_session = @selected_cycle.workout_sessions.find(params[:session_id]) if params[:session_id].present?
@selected_session ||= @selected_cycle.workout_sessions.first
```

#### State Persistence
- Equipment selection maintained across session switches
- Exercise substitutions preserved
- View mode remembered
- Default to first session when cycle changes

### 5. Collapsible Equipment Selector

#### Design
```
┌─────────────────────────────────────────────────┐
│ [🔧 Customize Equipment ▼]                      │  
└─────────────────────────────────────────────────┘
         ↓ (when expanded)
┌─────────────────────────────────────────────────┐
│ Available Equipment                             │
│ Select your available equipment to filter...    │
│                                                 │
│ ☑️ Barbell    ☑️ Dumbbells    ☐ Cable Machine  │
│ ☑️ Bench      ☐ Kettlebell   ☐ Resistance Bands│
│                                                 │
│ [Update Exercises] [All Equipment]              │
└─────────────────────────────────────────────────┘
```

- Hidden by default to reduce clutter
- Expandable/collapsible with clear toggle
- Maintains all current equipment functionality
- Updates only affect current session view

## Technical Requirements

### Turbo Frame Boundaries
```erb
<%= turbo_frame_tag "program_content" do %>
  <!-- Workout Settings (outside session frame) -->
  
  <%= turbo_frame_tag "workout_session" do %>
    <!-- Workout day tabs + session view -->
  <% end %>
<% end %>
```

### New Route Parameters
```ruby
# programs_controller.rb
def show
  @program = WorkoutProgram.find(params[:id])
  
  # Cycle selection (ID-based)
  @selected_cycle = find_selected_cycle
  
  # Session selection (ID-based) 
  @selected_session = find_selected_session
  
  # View mode
  @view_mode = params[:view_mode] || 'program'
  @session_view = params[:session_view] != 'full' # default to single session
  
  # Equipment state
  handle_equipment_selection
end

private

def find_selected_cycle
  if params[:cycle_id].present?
    @program.workout_cycles.find(params[:cycle_id])
  else
    @program.workout_cycles.first
  end
end

def find_selected_session
  if params[:session_id].present?
    @selected_cycle.workout_sessions.find(params[:session_id])
  else
    @selected_cycle.workout_sessions.first
  end
end
```

### View Components
```ruby
# New components to create:
app/views/programs/components/
├── _workout_settings.html.erb          # Combined settings section
├── _workout_day_tabs.html.erb          # Session navigation tabs  
├── _single_session_view.html.erb       # Individual workout display
└── _collapsible_equipment.html.erb     # Expandable equipment selector
```

## Implementation Phases

### Phase 1: Foundation (Day 1)
- [ ] Remove Schedule tab from navigation
- [ ] Create Workout Settings component structure
- [ ] Update controller to handle cycle_id/session_id parameters
- [ ] Implement ID-based URL routing

### Phase 2: Navigation (Day 2) 
- [ ] Create workout day tabs component
- [ ] Implement session selection with Turbo Frames
- [ ] Add single session view template
- [ ] Update state management for session switching

### Phase 3: Polish (Day 3)
- [ ] Create collapsible equipment selector
- [ ] Add session context display (Cycle 1 - Week 1)
- [ ] Implement next workout preview
- [ ] Add View Mode dropdown (Single | Full Program)

### Phase 4: Testing & Refinement (Day 4)
- [ ] Test all Turbo Frame interactions
- [ ] Verify state persistence across navigation
- [ ] Check mobile responsive behavior
- [ ] Performance testing with multiple cycles

## Success Metrics

### User Experience
- **Workout focus**: Users can access specific workout in ≤ 2 clicks
- **Navigation speed**: Session switching < 200ms (Turbo Frame benefit)
- **State persistence**: Equipment/substitution settings maintained across sessions
- **Mobile usability**: Workout day tabs work well on mobile devices

### Technical Performance  
- **Faster queries**: ID-based lookups vs. name matching
- **Reduced payload**: Single session vs. full program rendering
- **Better caching**: Session-specific Turbo Frame caching
- **Cleaner URLs**: Bookmarkable specific workouts

### Development Experience
- **Maintainable state**: Clear separation of cycle/session/equipment state
- **Extensible UI**: Easy to add new workout session types
- **Testable components**: Isolated workout settings and session views

## Edge Cases & Considerations

### Data Integrity
- **Missing cycle_id**: Fallback to first cycle
- **Missing session_id**: Fallback to first session in cycle  
- **Invalid IDs**: Graceful error handling with redirects
- **Empty cycles**: Handle programs with no workout sessions

### URL Compatibility
- **Bookmark compatibility**: Old name-based URLs redirect to ID-based
- **Deep linking**: Direct links to specific workouts work correctly
- **Parameter validation**: Ensure cycle belongs to program, session belongs to cycle

### User Experience Edge Cases
- **Cycle switching**: Reset to first session when changing cycles
- **Equipment state**: Maintain across session switches but reset on cycle change
- **Mobile navigation**: Workout day tabs scroll horizontally on small screens
- **Empty sessions**: Handle sessions with no exercises gracefully

## Future Enhancements

### Progressive Enhancement
- **Keyboard navigation**: Arrow keys to switch workout days
- **Gesture support**: Swipe left/right for session navigation
- **Voice commands**: "Show FB-A workout" voice navigation
- **Quick actions**: Keyboard shortcuts for common operations

### Advanced Features
- **Workout comparison**: Side-by-side session comparison
- **Progress tracking**: Previous performance overlay
- **Session notes**: Per-workout notes and modifications
- **Sharing**: Share specific workout sessions via URL

### Integration Opportunities
- **Calendar sync**: "Today's workout" based on calendar
- **Progress photos**: Session-specific photo attachments
- **Timer integration**: Rest timer embedded in session view
- **Equipment warnings**: Alert when selected session needs unavailable equipment

This restructure transforms the application from a program browser into a focused workout tool, matching user mental models and improving daily workout planning efficiency.