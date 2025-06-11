# PRD-06: Community & Program Sharing

## Overview
Build a thriving fitness community where users can share custom programs, track progress together, and learn from each other's success. Transform the app from individual tool to social fitness platform.

## Background & Motivation
Fitness is inherently social - people train together, share tips, and motivate each other. Currently, users can't share their successful programs or learn from others. Building community features creates network effects, improves retention, and provides unlimited program variety.

## Goals
1. Enable users to create and share custom programs
2. Build accountability through social features
3. Showcase success stories and transformations
4. Create program marketplace for trainers
5. Foster supportive fitness community

## User Stories

### As a program creator
- I want to share my successful program with others
- I want to see how many people use my program
- I want to get feedback and ratings
- I want recognition for helping others

### As a program consumer  
- I want to find programs for my specific goals
- I want to see real results from real users
- I want to ask questions to program creators
- I want to modify shared programs for my needs

### As a trainer
- I want to share free programs to build reputation
- I want to sell premium programs
- I want to manage my client base
- I want to showcase client results

## Functional Requirements

### Program Sharing System

#### Custom Program Builder
```ruby
class CustomProgram < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :program_reviews
  has_many :program_uses
  
  # Attributes
  # visibility: :private, :friends, :public
  # price: nil for free, integer for paid
  # difficulty_level: :beginner, :intermediate, :advanced
  # goals: [:strength, :muscle, :endurance, :sport_specific]
  # duration_weeks: integer
  # required_equipment: jsonb
  # description: text
  # before_after_photos: attachments
end
```

#### Program Discovery
```
Discover Programs

[Search bar: "powerlifting beginner"]

Filters:
- Goal: Strength ✓ Muscle □ Endurance □
- Level: Beginner ✓ Intermediate □ Advanced □  
- Duration: 4-12 weeks
- Equipment: Home gym ✓
- Rating: 4+ stars

Results (127 programs):

┌─────────────────────────┐
│ 💪 Starting Strength+   │
│ by @CoachMark (PRO)     │
│ ⭐ 4.8 (523 reviews)    │
│ 12 weeks • Strength     │
│ 2,847 active users      │
│ [Free] [View Program]   │
└─────────────────────────┘
```

#### Program Details Page
```
Starting Strength+ 
by @CoachMark • Follow

⭐⭐⭐⭐⭐ 4.8 (523 reviews)
👥 2,847 active users
📈 Avg result: +47lb squat in 12 weeks

[Start Program] [Save] [Share]

## Description
Perfect beginner program focusing on...

## Required Equipment
- Barbell, Rack, Bench

## Success Stories
[Carousel of before/after photos]
"Added 50lbs to my squat!" - @JohnD
"Finally broke 300lb deadlift" - @SarahK

## Program Structure
Week 1-4: Linear Progression
- Monday: Squat, Bench, Row
- Wednesday: Squat, OHP, Deadlift  
- Friday: Squat, Bench, Chin-ups
[See full program...]

## Reviews
[Review list with responses from creator]
```

### Social Features

#### Activity Feed
```ruby
class ActivityFeed
  def items_for_user(user)
    following_ids = user.following.pluck(:id)
    
    Activity.where(user_id: following_ids)
            .includes(:user, :trackable)
            .order(created_at: :desc)
            .limit(50)
  end
end

# Activity types:
# - PR achieved: "@Sarah just hit 225lb squat! 🎉"
# - Program completed: "@Mike finished Starting Strength+"
# - Program shared: "@CoachJen shared 'Glute Builder Pro'"
# - Transformation: "@Alex's 12-week progress photos"
```

#### Accountability Partners
```
Find Workout Partners

Location: Within 10 miles 📍
Schedule: Weekday mornings ✓
Goals: Strength training ✓
Level: Intermediate ✓

Suggested Partners:

[@Tony] 
"Looking for squat spotter"
- 2 miles away
- M/W/F 6am
- Current: 315lb squat
[Send Message]
```

#### Progress Sharing
- Before/after photos with privacy controls
- PR announcement cards
- Program completion certificates
- Monthly progress summaries
- Instagram-style stories

### Trainer Features

#### Trainer Dashboard
```
Trainer Dashboard

Active Clients: 47
Program Sales: $1,847 this month
Avg Rating: 4.9 ⭐

Quick Actions:
- Create new program
- Message all clients
- View client progress
- Schedule check-ins

Top Programs:
1. "Powerbuilding Pro" - 127 users
2. "Home Gym Hero" - 89 users
3. "Competition Prep" - 23 users
```

#### Client Management
```ruby
class TrainerClient < ApplicationRecord
  belongs_to :trainer, class_name: "User"
  belongs_to :client, class_name: "User"
  belongs_to :program
  
  # Features
  def send_check_in_reminder
    # Automated weekly check-ins
  end
  
  def grant_program_access
    # Give client access to paid program
  end
  
  def review_progress
    # Dashboard of client's workouts
  end
end
```

### Monetization Options

#### Program Pricing Tiers
- **Free**: Unlimited public programs
- **Premium**: $9-49 one-time purchase
- **Subscription**: $19-99/month with coaching
- **Custom**: Direct trainer-client agreements

#### Revenue Sharing
- Platform fee: 20% of paid programs
- Payment processing: Stripe integration
- Trainer payouts: Monthly
- Refund policy: 30-day guarantee

## Implementation Phases

### Phase 1: Basic Sharing (Week 1-2)
- Program creation tools
- Public/private programs
- Basic discovery page
- Program reviews

### Phase 2: Social Features (Week 3-4)
- User following system
- Activity feed
- Progress sharing
- Comments and likes

### Phase 3: Trainer Tools (Week 5-6)
- Trainer accounts
- Paid programs
- Client management
- Analytics dashboard

### Phase 4: Community Building (Week 7-8)
- Accountability partners
- Local gym groups
- Challenges/competitions
- Achievement badges

## Success Metrics
- 30% of users view shared programs monthly
- 10% of users share a program
- 5% trainer account conversion
- 4.5+ average program rating
- 20% of new users from referrals

## Safety & Moderation

### Content Guidelines
- Medical disclaimer required
- Prohibited: Dangerous techniques, PEDs, extreme diets
- Photo guidelines: Appropriate fitness attire
- Community standards: Supportive, inclusive

### Moderation System
- User reporting mechanism
- Automated content screening
- Trainer verification process
- Response time < 24 hours

## Future Enhancements
- Live workout streaming
- Virtual training sessions
- Team competitions
- Gym partnerships
- Supplement recommendations
- Form check video reviews
- AI program generation based on popular templates