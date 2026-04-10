
# Focus App Product Brief

## Product Name
Working title: **Pact**  
Alternative names:
- Rebound
- Anchor
- Recall
- Refocus

---

## 1. Product Summary

This app is a **standalone, offline-first iOS productivity app** for **knowledge workers and students**.

Its purpose is to help users **stay productive and complete tasks on time** by **proactively alerting them to the consequences of distraction**.

Unlike traditional focus timers or app blockers, this app does not rely on internet access, cloud sync, or heavy continuous sensing.  
Instead, it uses a **personalized focus contract** and **emotional consequence replay** to help users recover focus when they break their own commitment.

This app is designed as an **iPhone companion for deep work**, especially when the user is actually doing the main work on a **Mac or laptop**.

---

## 2. Core Problem

Knowledge workers and students often lose focus not because of external notifications alone, but because of **involuntary distraction habits** or **autopilot behavior**.

Existing focus tools often fail because:
- they only block software,
- they are too generic,
- they do not create immediate emotional meaning,
- they do not remind users what is personally at stake.

As a result, users break focus easily, lose time, and struggle to complete meaningful work on time.

---

## 3. Product Vision

Create a simple iOS app that turns a user’s own task, reason, and consequences into a **real-time emotional intervention** when they break a self-declared focus session.

The app should feel:
- personal,
- lightweight,
- emotionally sharp,
- minimal,
- Apple-native,
- fully usable without internet.

---

## 4. Core Product Concept

### Main Concept
**Personalized Focus Contract + Consequence Replay**

The user creates a short focus contract before starting work.

The contract contains:
- what they need to do,
- how long they want to focus,
- why the task matters,
- what is at stake if they fail,
- what tone they want the app to use.

When the user breaks the focus session, the app:
1. detects the break,
2. sends a local notification,
3. shows a consequence replay when the user returns,
4. encourages the user to resume focus.

---

## 5. Main Value Proposition

This is not a generic focus timer.

This app’s unique selling point is:

> It transforms the user’s own goals and consequences into immediate emotional friction when they break focus.

Why this is strong:
- personalized,
- difficult to imitate meaningfully,
- aligned with the app statement,
- works offline,
- emotionally memorable,
- easy to demo.

---

## 6. Target Users

### Primary users
- students
- university students
- knowledge workers
- junior developers
- PMs
- designers
- office workers doing deep work

### Typical user behavior
- works mainly on Mac/laptop
- keeps iPhone nearby
- gets distracted by checking phone
- starts tasks with good intentions
- struggles to return quickly after breaking focus

---

## 7. App Statement

> An app that helps knowledge workers and students stay productive and complete tasks on time by proactively alerting them to the consequences of distraction.

---

## 8. Core User Insight

The real issue is not just “distraction exists.”  
The issue is that users often break focus through **reflexive, low-awareness behavior**.

That means the app should not only track time.  
It should introduce a **small but meaningful interruption** at the moment focus is broken.

---

## 9. Product Principles

### 1. Standalone
The app must function without internet, cloud sync, login, or backend.

### 2. Offline-first
All key functionality must work fully on-device.

### 3. Minimal
The app should focus on one strong loop, not many features.

### 4. Personalized
The messaging should come from the user’s own input.

### 5. Emotionally meaningful
The app should not just say “stay focused.”  
It should remind the user what this task means.

### 6. Honest about technical scope
The app should not claim to know exactly which app the user opened after leaving.  
It only detects that the user **broke a self-declared focus session**.

---

## 10. User Flow Overview

### Step 1 — Onboarding
The app explains:
- focus is a promise, not just a timer,
- the app helps reflect the cost of breaking focus,
- the user will create personal focus contracts.

### Step 2 — Create Focus Contract
The user enters:
- task
- duration
- why it matters
- what is at stake
- tone

### Step 3 — Start Focus Session
The user taps **Start Focus**.

The app:
- starts the session,
- opens the active focus screen,
- starts Live Activity.

### Step 4 — User Locks iPhone and Works
The user may lock the iPhone and continue working on Mac/laptop.

The app does not disturb them.

### Step 5 — Focus Break Happens
The user opens the phone or leaves the session.

The app treats this as:
- a broken focus session,
- a possible distraction moment.

### Step 6 — Local Notification
The app sends a local notification with a short message based on the focus contract.

### Step 7 — Consequence Replay
When the user returns to the app, they see:
- break duration,
- reminder of why the task matters,
- a personalized consequence line,
- actions to resume or end.

### Step 8 — Reflection Report
At the end of the session, the app shows:
- total focus time,
- total break time,
- number of breaks,
- summary.

---

## 11. Primary Screens

### 1. Onboarding Screen
Purpose:
- explain the app simply

Contents:
- short intro text
- CTA button

### 2. Create Focus Contract Screen
Fields:
- Task
- Duration
- Why this matters
- What is at stake
- Tone selector

CTA:
- Start Focus Session

### 3. Active Focus Session Screen
Contents:
- large timer
- task title
- short reason
- status label

### 4. Live Activity State
Contents:
- task summary
- remaining time or elapsed time
- status

### 5. Break Alert Notification
Contents:
- short personalized title/body
- emotional but concise reminder

### 6. Consequence Replay Screen
Contents:
- break duration
- reminder text
- consequence message
- Resume Focus button
- End Session button

### 7. Reflection Report Screen
Contents:
- focused time
- lost time
- number of breaks
- session summary
- Start New Session button

---

## 12. Core Feature Set for MVP

### Must Include

#### A. Focus Contract
User can create a contract containing:
- task name
- focus duration
- why it matters
- consequence
- tone

#### B. Focus Session
User can:
- start a session
- see session status
- keep session running while iPhone is locked

#### C. Live Activity
Show:
- current task
- current timer
- focus state

#### D. Break Detection
When app/session is interrupted:
- record the break
- measure how long it lasts

#### E. Local Notification
Trigger a local notification after focus break starts or based on defined logic.

#### F. Consequence Replay
When the user returns:
- show the emotional intervention screen

#### G. Reflection Report
Summarize:
- focus time
- break time
- number of breaks

#### H. Local Persistence
Save all sessions and contracts on-device.

---

## 13. Features to Exclude from MVP

Do not build these in the first version:
- login
- user accounts
- cloud sync
- AI chatbot
- voice assistant
- social competition
- friend accountability
- gamification coins/streaks
- website/app blocking dependencies
- internet-only services
- analytics dashboard that is too advanced
- cross-device monitoring
- Mac app
- camera-based proof of work
- continuous sensor tracking
- intrusive machine learning features

---

## 14. Personalization System

The app becomes personal through **user-authored input**, not cloud AI.

### Inputs used for personalization
- Task
- Why it matters
- Consequence if failed
- Tone choice

### Tone options
- **Supportive**
- **Direct**
- **Savage**

### Example transformation

#### User input
- Task: Bikin API
- Why it matters: Besok review mentor
- Consequence: Kalau molor, tim ikut ketahan

#### Notification example
- “Task ini penting buat review besok.”
- “Kalau molor, timmu ikut ketahan.”

#### Consequence replay example
- “You broke focus for 03:12.”
- “Tadi kamu bilang task ini penting buat review besok.”
- “Kalau terus kabur, kerjaanmu makin molor.”

---

## 15. Technical Scope and Truthfulness

The app must be technically honest.

### What the app CAN say
- the user started a focus session
- the focus session was interrupted
- the user left and returned
- break duration can be measured
- reminders can be shown

### What the app SHOULD NOT claim
- exact detection of which distracting app was opened
- exact knowledge of whether the user was truly distracted
- exact monitoring of productivity on Mac
- real-time behavioral surveillance

Correct framing:
> The app detects a break from a self-declared focus session and responds immediately.

---

## 16. Recommended Apple-Native Technologies

### SwiftUI
Use for all app screens and UI.

### SwiftData
Use for local storage of:
- contracts
- sessions
- break logs
- history

### ActivityKit
Use for Live Activity showing ongoing focus session.

### WidgetKit
Use only as needed for Live Activity presentation.

### UserNotifications
Use for local notifications.

### App Lifecycle / Scene Phase
Use to detect transitions such as:
- active
- inactive
- background

### Haptics
Use small haptic feedback for:
- start focus
- resume focus
- session end

---

## 17. Suggested Data Model

### FocusContract
- id
- createdAt
- taskTitle
- durationMinutes
- whyItMatters
- consequenceText
- tone

### FocusSession
- id
- contractId
- startedAt
- endedAt
- status
- totalFocusSeconds
- totalBreakSeconds
- breakCount

### FocusBreak
- id
- sessionId
- breakStartedAt
- breakEndedAt
- durationSeconds

### ToneType
- supportive
- direct
- savage

### SessionStatus
- active
- paused
- completed
- abandoned

---

## 18. Suggested Business Logic

### Session start
When user taps Start Focus:
- create FocusSession
- set status = active
- store start time
- start Live Activity

### Break start
When app/session leaves active focus state:
- create a FocusBreak start timestamp
- optionally schedule local notification

### Break end
When user returns:
- close active break
- calculate break duration
- update session totals
- show consequence replay screen

### Session end
When user taps End Session or timer completes:
- close session
- calculate totals
- end Live Activity
- show reflection report

---

## 19. Notification Strategy

Use local notifications only.

### Role of notification
The notification is not the full intervention.  
It is only the **attention hook**.

### Main emotional intervention happens here
- Consequence Replay screen in the app

### Notification structure
- title: short
- body: one emotionally relevant line
- based on user contract

### Example notification titles
- Focus broken
- Stay on contract
- Back to your task

### Example notification bodies
- “Tadi kamu bilang ini penting buat review besok.”
- “Kalau molor, timmu ikut ketahan.”
- “Balik sekarang sebelum break ini makin mahal.”

---

## 20. Reflection Report Logic

At the end of a session, show:
- planned duration
- actual focused duration
- total break duration
- break count
- summary sentence

### Example summary
- “You protected 21 out of 25 minutes.”
- “You lost 4 minutes in 2 breaks.”
- “You came back. That still matters.”

This should feel reflective, not overly punitive.

---

## 21. UX and Visual Direction

The app should feel:
- minimal
- native to iOS
- calm
- clean
- intentional
- emotionally sharp but not chaotic

### UI style guidance
- large type where needed
- clean spacing
- simple cards
- few colors
- avoid visual clutter
- no meme aesthetics
- no excessive red warning everywhere

### Emotional tone
The app should confront gently, not shame aggressively.

Roasting may exist, but only as an optional tone.

---

## 22. Risks

### 1. Tone becomes too harsh
If messaging is too aggressive, users may feel judged and quit.

### 2. Too many notifications
If the app notifies too often, users may disable notifications.

### 3. Setup feels too heavy
If contract creation takes too long, users may not start sessions.

### 4. False positives
Not every app exit means meaningful distraction.

### 5. Emotional novelty fades
Repeated messages may lose impact over time.

---

## 23. Assumptions

This product assumes:
- users are willing to define what is at stake,
- personalization is more effective than generic motivation,
- an emotional reminder can help users return faster,
- a simple iPhone companion is enough while working on a Mac.

---

## 24. Unknowns to Validate

Need testing for:
- which tone works best,
- how quickly users return after notification,
- whether users prefer short or long sessions,
- whether they feel helped or judged,
- whether contract setup is worth the effort.

---

## 25. User Testing Questions

1. How do you currently try to stay focused?
2. Would writing your task and consequence feel useful or annoying?
3. Would a personalized notification help you return faster?
4. Which tone would work best for you: Supportive, Direct, or Savage?
5. What makes the replay screen effective: time lost, task reminder, or consequence?
6. Would you use this app while working on a Mac and keeping your iPhone nearby?
7. What would make you uninstall this app after one week?

---

## 26. MVP Success Criteria

The first version is successful if:
- users understand the concept quickly,
- they can create a contract in under 1 minute,
- they complete a full focus loop,
- they feel the consequence replay is meaningful,
- they return to focus at least sometimes,
- the app feels lighter than generic focus tools.

---

## 27. Product Positioning Statement

This is not a focus timer that simply counts minutes.

This is a **personalized behavioral intervention app** that helps users recover from broken focus by replaying the emotional cost of distraction using their own words, at the exact moment they need it.

---

## 28. Final Product Summary

The app is a simple, offline, standalone iPhone focus companion for students and knowledge workers.

It works by asking users to define:
- what they need to do,
- why it matters,
- what is at stake.

Then, when they break their focus session, the app immediately reflects those consequences back to them through:
- local notifications,
- a consequence replay screen,
- and a session summary.

The product is intentionally narrow:
- one strong loop,
- one emotionally meaningful feature,
- one clear identity.

That identity is:

> helping people come back to focus by reminding them what their distraction is costing them.
