# Postura — Demo Evidence

This folder contains visual evidence of the FAR AWAY 2026 Round 2 implementation.

## Round 2 User Flow

The evidence should demonstrate the complete operational-readiness flow:

1. User prepares to start an activity.
2. Postura performs a readiness check.
3. The application evaluates the live posture state.
4. A conflict is detected when the readiness condition is not satisfied.
5. The conflict is presented before the user starts the activity.
6. The user corrects the posture.
7. The application evaluates the condition again.
8. The user is allowed to proceed once the conflict is resolved.

## Required Evidence

### 1. BLE Connection

Show that the Postura application is connected to the physical wearable.

Suggested filename:

`01-ble-connected.png`

### 2. Readiness Check

Show the application immediately before or during the readiness evaluation.

Suggested filename:

`02-readiness-check.png`

### 3. Conflict Detected

Show the application presenting the detected conflict before the activity/session starts.

Suggested filename:

`03-conflict-detected.png`

### 4. Posture Correction

Show the user correcting the posture or the application displaying the corrected posture state.

Suggested filename:

`04-posture-corrected.png`

### 5. Ready State

Show that the conflict has been resolved and the user is ready to proceed.

Suggested filename:

`05-ready.png`

### 6. Activity Started

Show the final state after the readiness condition has been satisfied and the activity/session can begin.

Suggested filename:

`06-activity-started.png`

## Evidence Principle

The screenshots should tell the story without requiring the judge to inspect the source code.

The most important sequence is:

```text
READY TO START
      ↓
READINESS CHECK
      ↓
CONFLICT DETECTED
      ↓
USER CORRECTS
      ↓
CHECK AGAIN
      ↓
READY
      ↓
ACTIVITY STARTS
```

## Important

The screenshots should represent the actual working Postura application.

Do not use mock screens or manually edited screenshots as evidence of functionality.

If a particular state cannot currently be demonstrated, it should be identified as pending rather than presented as completed.
