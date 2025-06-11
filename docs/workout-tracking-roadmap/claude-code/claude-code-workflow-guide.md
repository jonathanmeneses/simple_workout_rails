[Creates models with migrations, associations, and validations]# Claude Code Workflow Guide for Simple Workout Tracking

## How to Use This Task List with Claude Code

This guide shows exactly how to work with Claude Code to implement each task from the task list efficiently.

## Setting Up Your Claude Code Session

### 1. Initial Context Setting
Start each Claude Code session with:
```
I'm working on the Simple Workout Tracking Rails app. 
Current directory: /Users/jonathanmeneses/Documents/Development/side_projects/simple_workout_tracking

Please review the current state by checking:
- Gemfile for dependencies
- db/schema.rb for database structure  
- app/models/ for domain models
- Current git status

I'll be working on TASK-XXX: [Task Description]
```

### 2. Task Implementation Pattern
For each task, follow this conversation flow:

**Step 1: Review Current State**
```
Human: Let's implement TASK-001: Fix Equipment Selection Persistence. 
Please first review the current implementation in:
- app/controllers/programs_controller.rb
- app/views/programs/components/_equipment_selector.html.erb

Then create a plan for fixing the persistence issue.
```

**Step 2: Implement Solution**
```
Human: That plan looks good. Please implement the changes, making sure to:
1. Preserve equipment selection in session
2. Update all forms to maintain state
3. Test that substitutions update correctly
```

**Step 3: Verify and Test**
```
Human: Please create a simple test to verify the equipment persistence works correctly. 
Also show me how to manually test this in the browser.
```

## Example Claude Code Conversations

### Example 1: Model Creation Task (TASK-009)

```
Human: Let's work on TASK-009: Create Workout Logging Models. Please create the three models we need: WorkoutLog, ExerciseLog, and SetLog with appropriate associations and validations.

Claude: I'll create the workout logging models with proper associations and validations. Let me start by generating the models with their migrations.

[Creates models with migrations, associations, and validations]