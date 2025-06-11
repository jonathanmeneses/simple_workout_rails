# PRD-04: Mobile-First Gym Experience

## Overview
Optimize the entire application for mobile use in gym environments, focusing on one-handed operation, visibility in poor lighting, and resilience to sweaty fingers and dropped phones.

## Background & Motivation
Users primarily access workout apps during their gym sessions on mobile devices. Current responsive design works but isn't optimized for actual gym conditions: poor lighting, sweaty hands, time pressure, and need for quick inputs between sets. Mobile experience directly impacts workout quality.

**Current Foundation Status (2025-01-06):**
- ✅ Complete exercise database with 223 fully-attributed exercises
- ✅ Functional substitution engine with standardized equipment system
- ✅ Solid data foundation ready for mobile optimization

## Goals
1. Enable true one-handed operation
2. Optimize for gym lighting conditions  
3. Minimize required interactions
4. Prevent accidental inputs
5. Support quick glances between sets

## User Stories

### As a gym user
- I want to log sets with one thumb while holding dumbbells
- I want to see my next exercise without scrolling
- I want large buttons I won't miss with sweaty fingers
- I want the screen to stay on during my workout

### As a circuit trainer
- I want to quickly move between exercises
- I want to see multiple exercises at once
- I want minimal taps to log supersets
- I want visual exercise order indicators

## Functional Requirements

### Mobile UI Optimizations

#### 1. Workout View Redesign
```
┌─────────────────────────┐
│ Chest Day - Week 2      │
│ Exercise 3 of 6         │
│ [===========----] 55%   │
├─────────────────────────┤
│ BENCH PRESS             │
│ Previous: 185×8,8,7     │
│                         │
│ Set 1: [8] @ [185] ✓   │
│ Set 2: [8] @ [185] ✓   │
│ Set 3: [_] @ [185] 👈  │
│                         │
│ [Large Complete Button] │
├─────────────────────────┤
│ Next: Incline DB Press  │
└─────────────────────────┘
```

#### 2. Smart Input Controls
- Number steppers (+5/-5 for weight)
- Rep buttons (6,8,10,12,15,20)
- "Same as last" quick fill
- Swipe right to complete set
- Swipe left to skip exercise

#### 3. Gym-Specific Features
```javascript
// Prevent screen sleep
let wakeLock = null;
async function requestWakeLock() {
  try {
    wakeLock = await navigator.wakeLock.request('screen');
  } catch (err) {
    console.log('Wake Lock error:', err);
  }
}

// Vibration feedback
function completeSet() {
  if (navigator.vibrate) {
    navigator.vibrate(100); // Short buzz
  }
}
```

#### 4. High Contrast Mode
- Pure black background option
- Extra bold fonts
- High contrast colors
- Larger touch targets (60×60px)
- Reduced animations

### Gesture Controls
- **Swipe Right**: Complete set
- **Swipe Left**: Skip/previous
- **Long Press**: Add note
- **Pinch**: Zoom exercise details
- **Shake**: Undo last action

### Progressive Web App Features
```json
// manifest.json
{
  "name": "Simple Workout Tracking",
  "short_name": "GymTrack",
  "display": "fullscreen",
  "orientation": "portrait",
  "theme_color": "#000000",
  "background_color": "#000000"
}
```

- Installable to home screen
- Offline functionality
- Push notifications for rest timers
- Background sync for data

### Adaptive Layouts

#### Portrait Mode (Default)
- Single exercise focus
- Large input areas
- Minimal scrolling
- Fixed bottom controls

#### Landscape Mode (Optional)
- Split view: current + next exercise
- Side-by-side set logging
- Useful for tablet users
- Exercise video preview

## Technical Requirements

### Performance Optimizations
- Service Worker for offline use
- Aggressive caching of workout data
- Optimistic UI updates
- Compressed assets
- Lazy load non-critical features

### Touch Optimization
```css
/* Prevent double-tap zoom */
touch-action: manipulation;

/* Large touch targets */
.touch-target {
  min-height: 60px;
  min-width: 60px;
  padding: 12px;
}

/* Prevent text selection */
user-select: none;
-webkit-user-select: none;
```

### Device-Specific Features
- iOS: Haptic feedback for iPhone
- Android: Material Design patterns
- Watch OS: Basic companion app
- Tablet: Multi-column layouts

## Implementation Phases

### Phase 1: Core Mobile UX (Week 1)
- Redesign workout logging screen
- Implement gesture controls
- Add wake lock functionality
- Optimize touch targets

### Phase 2: PWA & Offline (Week 2)
- Service Worker setup
- Offline data sync
- Home screen installation
- Push notifications

### Phase 3: Polish & Features (Week 3)
- High contrast mode
- Haptic feedback
- Rest timer widgets
- Voice commands (experimental)

## Success Metrics
- Mobile usage > 85% of all sessions
- Average set logging time < 3 seconds
- Mis-tap rate < 2%
- PWA installation rate > 40%
- Offline usage > 20% of sessions

## Accessibility Requirements
- VoiceOver/TalkBack support
- Minimum contrast ratio 7:1
- Font scaling support up to 200%
- One-handed reachability
- Color-blind friendly palettes

## Edge Cases
- Very small screens (< 320px)
- Glove mode for cold gyms
- Brightness adaptation
- Network switching mid-workout
- Battery saving mode impacts

## Future Enhancements
- Apple Watch app
- Wear OS support  
- Voice-controlled logging
- Bluetooth equipment integration
- AR exercise demonstrations
- Gesture-based plate calculator