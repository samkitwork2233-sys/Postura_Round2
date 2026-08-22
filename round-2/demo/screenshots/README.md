# Round 2 Demo Screenshots

This folder contains visual evidence of the Postura implementation for **FAR AWAY 2026 — Round 2, Challenge #728: Operational Readiness: Conflict Check**.

The screenshots demonstrate the complete user flow from connecting the wearable to starting an activity after resolving a detected conflict.

## Demo Flow

```text
BLE Connected
      ↓
Readiness Check
      ↓
Conflict Detected
      ↓
Posture Corrected
      ↓
Ready
      ↓
Activity Started
```

## Screenshots

### 1. BLE Connected

**File:** `ble-connected.jpg`

Shows the Postura application connected to the wearable through Bluetooth Low Energy.

This establishes that the application is receiving data from the physical Postura device.

---

### 2. Readiness Check

**File:** `readiness-check.jpg`

Shows the user initiating the readiness check before starting an activity or session.

The application evaluates the current live posture state at this point.

---

### 3. Conflict Detected

**File:** `conflict.jpg`

Shows the application detecting and presenting a conflict before the user starts the activity.

This is the key Round 2 interaction.

The conflict is presented before the user commits to the action.

---

### 4. Posture Corrected

**File:** `corrected.jpg`

Shows the user correcting the posture after the conflict has been detected.

The application can then evaluate the updated posture state.

---

### 5. Ready

**File:** `ready.jpg`

Shows that the readiness condition has been satisfied after correction.

The user can now proceed with the activity or session.

---

### 6. Activity Started

**File:** `started.jpg`

Shows the final state after the readiness check has been successfully completed and the activity or session has started.

---

## Complete Round 2 Flow

The screenshots together demonstrate:

```text
User prepares to start
        ↓
Readiness Check
        ↓
Conflict?
   ┌────┴────┐
   ↓         ↓
  No        Yes
   ↓         ↓
 Ready     Conflict
   │         ↓
   │      Correction
   │         ↓
   │     Check Again
   │         ↓
   └────→ Ready
             ↓
       Activity Starts
```

## Evidence Principle

These screenshots should show the **actual Postura application and actual prototype workflow**.

They should not be manually edited or fabricated to represent functionality that has not been demonstrated.

The purpose of this evidence is to allow a judge to understand the Round 2 flow quickly without inspecting the entire source code.

## Round 2 Requirement

The evidence focuses on the core requirement of:

**Readiness before an action → early conflict detection → conflict presented before commitment → correction → re-check → action.**

The screenshots should therefore be evaluated as one continuous user flow rather than as unrelated application screens.
