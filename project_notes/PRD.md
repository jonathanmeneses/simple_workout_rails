# ChatPRD: Hierarchical, Flexible Workout Program Generator (Rails/Cloud Code Ready)

## tl;dr / Executive Summary

A portfolio-focused web and mobile app delivering dynamic workout
programs with deep flexibility. Programs are built hierarchically
(Program → Cycle → Session → Exercise) and can be browsed, copied, or
personalized. Both unauthenticated and authenticated users enjoy a
seamless experience: browse program structures, substitute exercises
based on equipment and preference, and print/share as PDFs.
Authenticated users can create persistent copies of programs, substitute
exercises, and personalize sessions for future reuse. V0 is optimized
for print/mobile-reference and robust substitution logic, with
architecture for significant future extensibility.

------------------------------------------------------------------------

## Goals

### Business Goals

- Showcase advanced product strategy and technical execution in
  fitness-focused application design.

- Demonstrate thoughtful Rails modeling, RESTful API, and modern
  front-end patterns.

- Provide a clean admin editing and data seeding experience for future
  growth.

- Serve as a best-in-class portfolio site to engage both engineering and
  product peers.

### User Goals

- Access progressive, effective workout programs with zero confusion.

- Select (or swap) exercises based on available equipment or training
  style—on-the-fly.

- Easily print/share PDFs or pull up workouts on any device during
  training.

- Authenticated users: Build and save personal program variants without
  friction.

- Enjoy clarity through well-structured, jargon-free cycles and
  sessions.

- No ads, unnecessary community features, or complicated onboarding.

### Non-Goals

- No weight/set logging or detailed workout completion tracking in V0.

- No open program editing (admin-only content management).

- No social sharing, program publishing, or community features at
  launch.

------------------------------------------------------------------------

## User Stories

### Unauthenticated User

- As a guest, I can browse all available workout programs, review their
  structure, and view cycle/session breakdowns with exercise
  prescriptions.

- I can enter my equipment and basic preferences up front or as I view
  each workout/session.

- Within a workout or session, I can substitute prescribed exercises
  with curated alternatives based on my equipment and the session’s goal
  (e.g., movement pattern, body part).

- I may print or export to PDF any program, cycle, or single-session
  view, with clear whitespace for note-taking.

- I cannot save, persist, or revisit personal program copies—edits are
  session-only.

### Authenticated User

- As a logged-in user, I can copy any program template as a personal
  variant and save it to my account.

- For my personal copy, I can select/cycle equipment and exercise
  alternatives for each session as I prefer.

- I may personalize each session—even if the template repeats it across
  multiple weeks/cycles.

- I can revisit and re-edit my programs at any time, maintaining all
  substitutions and preferences.

- All print/export features remain available for any level of my
  personal program: full plan, cycle, or session.

- I do not track actual workout completions, sets, or reps in V0.

### Admin (not public)

- As an admin, I can create and edit new programs, cycles, sessions, and
  prescribed exercises.

- I can curate alternative exercises and assign substitution logic by
  movement pattern, body part, equipment needs, and training goal at
  both the session and exercise levels.

- My changes affect what is available for both public and authenticated
  user journeys.

------------------------------------------------------------------------

## Functional Requirements

### Hierarchical Program Data Model

- **WorkoutProgram**: Top-level, descriptive and discoverable object.

  - Has many **Cycles**

- **Cycle**: Represents a mesocycle or major phase of training.

  - Belongs to a WorkoutProgram; has many **Sessions**

  - Metadata: description of phase, training focus, length,
    rotation/deload rules

- **Session**: Represents one workout "day."

  - Belongs to a Cycle; has many **Exercises**

  - Metadata: session goal, targeted body parts/movement patterns,
    allowed modalities/methods

  - Sessions may repeat week-to-week (can be templated and personalized
    by user)

- **Exercise**: Individual movement within a session, with sets/reps
  prescribed

  - Metadata: default prescription, method/tempo (optional, extensible),
    movement pattern, body part, equipment required

  - Each exercise has a curated set of **Alternatives**—valid
    substitutions based on admin curation

- **ExerciseAlternative**: Alternative exercise, mapped to the same
  movement pattern/goal/equipment as its parent, available for swap

### Equipment & Preference Input

- User may select equipment/preference either globally or
  session-by-session.

- Substitution dropdowns or option cycling presented contextually within
  each session/workout.

- (Admin-provided) equipment tags guide what is eligible for
  substitution.

### Plan Personalization Logic

- Unauthenticated: Substitution triggers filtered by user input or as
  they interact, but not saved (print/export only).

- Authenticated: Substitutions are persisted for each user's copy of a
  program; users can iteratively personalize further.

### Print & Export

- Export/print is a first-class action for every view (full
  program/cycle/session).

- Print styling prioritizes whitespace, readable tables, and key meta
  (sets, reps, movement, space for notes).

- Print view auto-populates with user's selected substitutions
  (including session-only swaps if unauthenticated).

### Admin Content Management (Not User-Facing)

- Admins can create, edit, reorder, and remove programs, cycles,
  sessions, exercises, and alternatives.

- Exercise alternatives are curated per movement pattern/body
  part/equipment and attached to base exercises.

------------------------------------------------------------------------

## User Experience

### Unauthenticated Journey

1.  **Browse Programs**: See a gallery or list of all available program
    templates, each with a summary and preview.

2.  **Select Program → View Structure**: Drill into program → view
    cycles (macro structure) → sessions (weekly breakdown) → exercises
    (lists/sets/reps).

3.  **Equipment/Preference Input**: Optionally select global or
    per-session equipment (e.g., “no barbell,” “dumbbells only”) with
    prominent toggle or dropdown.

4.  **Substitute Exercises**: For each prescribed exercise, see a
    curated swap button or dropdown displaying eligible alternatives.
    Substitution logic uses equipment constraints and movement/session
    goals.

5.  **Print/Export**: At any stage, print or save as PDF the part of the
    program being viewed (entire plan, a single cycle, or a single
    session). Printers/PDFs optimized with grids, whitespace, and
    session/exercise metadata.

### Authenticated Journey

1.  **Register/Login**: Simple user signup (email/OAuth, as needed).

2.  **Copy Program**: Click “Make Your Own Copy” or similar; program is
    cloned into the user’s account.

3.  **Personalize Equipment/Preferences**: Set global or per-session
    equipment and other preferences.

4.  **Personalize Sessions**: Swap exercises freely, and edit substitute
    selections for each session, even if sessions are repeated in the
    template.

5.  **Save & Revisit**: Re-access and edit this personal program
    anytime.

6.  **Print/Export**: As with guest, print/PDF export is always
    available—output always includes current alternatives.

### Admin Journey (Not Exposed)

- Create/edit programs, cycles, sessions, and exercises.

- Curate substitution options per exercise, mapped by
  pattern/body/equipment/goal.

- Preserve extendibility for richer prescription meta (tempo, method,
  etc.)

------------------------------------------------------------------------

## Data and Substitution Logic

- Each session and exercise is tagged by movement pattern, target body
  part, and method/goal fields.

- Substitutions are filtered using these tags and user-selected
  equipment (plus preference options, as needed).

- Substitution options are curated—only visible alternatives as chosen
  by admin for V0.

- Architecture (model/fields/endpoints) supports expansion to
  dynamic/more intelligent substitutions, and richer session meta
  (tempo, effort, method) in later versions.

------------------------------------------------------------------------

## Print/Export Requirements

- All views (program, cycle, session) feature one-click print/PDF, with
  clear formatting.

- Print view always reflects all current substitutions and preferences.

- Layout is whitespace-optimized for pen-and-paper note-taking.

- Black-and-white, printer-safe, phone-readable (media-query driven).

------------------------------------------------------------------------

## Technical & Cloud Code / Rails Implementation Guidance

### Data Model

- WorkoutProgram has_many Cycle

- Cycle has_many Session

- Session has_many Exercise

- Exercise has_many ExerciseAlternative

### Key Models

- WorkoutProgram: title, description, public flag

- Cycle: workout_program_id, title, description, start_week, end_week,
  priority/focus/goal meta (JSON for extensibility)

- Session: cycle_id, title, description, day_of_week,
  goal/body_part/movement meta (JSON for extensibility)

- Exercise: session_id, name, sets, reps, tempo (optional), method
  (optional), movement_pattern, equipment, alternatives relationship

- ExerciseAlternative: exercise_id, name, movement_pattern, equipment,
  method/goals

### RESTful Design

- REST endpoints for all models (CRUD for admin role; read-only for
  guests/users where appropriate)

- User copies of WorkoutProgram (UserProgram) inherit program structure,
  with persisted substitutions/overrides at the session/exercise level

- Print/export endpoints: route outputs as clean, printer-optimized HTML
  or trigger browser print/PDF

### Personalization

- Authenticated user programs can override any session/exercise (but
  start as complete copies).

- Substitutions create “overrides” at the
  session/exercise/UserProgramExercise level.

- V0: No logging/completion/rep tracking.

### Admin Content

- Admin/console-only UI for managing programs, cycles, sessions,
  exercises, and exercise alternatives

- No user-facing creation or public program publishing at V0

------------------------------------------------------------------------

## Future Extensibility

- Add tracking/completion/history objects per session for user logging
  (V2+)

- Expand method/tempo/effort fields for richer prescription and
  intelligent substitution

- Enable user-to-user sharing or publishing of templates and
  personalizations (future)

- Allow dynamic/algorithmic substitution logic (rules engine,
  AI/matching by session goal, etc.)

- Add notification, calendar, reminder integrations as desired

------------------------------------------------------------------------

## Metrics & Success

- Unique (guest and registered) user sessions

- Number of personalized program copies created

- Number and diversity of exercise substitutions performed

- Print/PDF exports by program, day, and user cohort

- Portfolio/engagement tracking via resume/LinkedIn mention, engineering
  community feedback

------------------------------------------------------------------------

## Narrative

Fitness tools are usually either too simple to help real people adapt to
their equipment and preferences—or too cluttered for swift daily use.
This generator makes programs accessible, flexible, and printable for
every user, while opening the door for deep, personal customization.
Simplicity is its calling card. When you're ready to track results, V2
will already have the foundation in place for full logging and adaptive
training.

------------------------------------------------------------------------

## Footer

Built for product leaders, engineers, and real-world lifters who value
clarity as much as strength.
