# Postura — Round 2 Demo

## 1. Demo Overview

This document explains how to evaluate the Round 2 **Readiness Check / Conflict Detection** workflow implemented in Postura.

The demonstration uses:

- Postura wearable
- ESP32
- MPU6050 IMU sensor
- Bluetooth Low Energy (BLE)
- Postura Flutter application

The Round 2 feature adds a readiness layer before an activity or session begins.

Instead of allowing an activity to start immediately, the application first evaluates the user's current posture using live posture data received from the wearable.

---

## 2. Round 2 Problem Addressed

A user may begin an activity while already sitting or standing in an unsuitable posture.

Traditional posture monitoring generally focuses on detecting poor posture while an activity is already in progress.

Postura adds a **pre-activity readiness check**.

The application evaluates the user's current posture before allowing the activity or session to begin.

The workflow is:

**Current Posture → Readiness Check → Conflict Detection → Posture Correction → Ready → Activity Started**

---

## 3. Demo Flow

The complete Round 2 demonstration follows these steps:

1. Connect the Postura wearable through BLE.
2. Start the readiness check.
3. Evaluate the current live posture.
4. Detect a posture conflict if the readiness condition is not satisfied.
5. Allow the user to correct their posture.
6. Re-evaluate the updated posture.
7. Mark the user as ready when the condition is satisfied.
8. Start the activity/session only after readiness is achieved.

---

# 4. Step 1 — BLE Connected

The Postura application first connects to the physical Postura wearable using Bluetooth Low Energy (BLE).

The wearable provides live posture information to the application.

### Evidence

![BLE Connected](./screenshots/ble-connected.jpeg)

The screenshot demonstrates that the application is connected to the physical Postura wearable and is receiving posture information through BLE.

---

# 5. Step 2 — Readiness Check

Before starting an activity or session, the user initiates the **Readiness Check**.

At this point, the application evaluates the current live posture state received from the wearable.

The readiness check acts as a gate before the activity begins.

### Evidence

![Readiness Check](./screenshots/readiness-check.jpeg)

The screenshot demonstrates the user initiating the readiness evaluation before beginning an activity or session.

---

# 6. Step 3 — Conflict Detected

If the current posture does not satisfy the configured readiness condition, the application detects a conflict.

For the Round 2 prototype demonstration, the readiness threshold is configured to **15°**.

If the measured posture deviation exceeds the readiness threshold, the application presents a conflict to the user.

The conflict is presented **before the activity begins**.

### Evidence

![Conflict Detected](./screenshots/conflict.jpeg)

The screenshot demonstrates the application detecting a posture conflict during the readiness check.

---

# 7. Step 4 — Posture Corrected

After the conflict is detected, the user corrects their posture.

The application then evaluates the updated live posture state received from the wearable.

This creates a feedback loop:

**Conflict → User Correction → Re-evaluation**

### Evidence

![Posture Corrected](./screenshots/corrected.jpeg)

The screenshot demonstrates the updated posture state after the user corrects their posture.

---

# 8. Step 5 — Ready

Once the user's posture satisfies the readiness condition, the application changes the state to **Ready**.

The user can now proceed with the intended activity or session.

### Evidence

![Ready](./screenshots/ready.jpeg)

The screenshot demonstrates that the user has successfully passed the readiness check.

---

# 9. Step 6 — Activity Started

After the readiness condition is satisfied, the user can start the activity or session.

The activity is therefore started only after the pre-activity posture evaluation has been completed successfully.

### Evidence

![Activity Started](./screenshots/started.jpeg)

The screenshot demonstrates the activity/session being started after successful readiness evaluation.

---

# 10. Complete Round 2 Workflow

The complete workflow can be summarized as:

```text
        BLE Connection
              │
              ▼
      Live Posture Data
              │
              ▼
       Readiness Check
              │
              ▼
     ┌──────────────────┐
     │ Posture satisfies │
     │ readiness state?  │
     └────────┬─────────┘
              │
        ┌─────┴─────┐
        │           │
       NO          YES
        │           │
        ▼           ▼
 Conflict        Ready
 Detected          │
        │           │
        ▼           ▼
 User Corrects  Activity
   Posture       Started
        │
        ▼
 Re-evaluate
        │
        └──────────────► Ready
11. Technical Implementation

The Round 2 readiness workflow operates on the existing live posture sensing pipeline.

Hardware
MPU6050 IMU sensor
ESP32 microcontroller
Vibration feedback mechanism
Power management circuitry
BLE communication
Software
Flutter application
BLE communication layer
Live posture data processing
Readiness evaluation logic
Conflict detection state
Ready state
Activity/session start control

The Round 2 implementation primarily adds the application-level readiness and conflict detection layer on top of the existing posture sensing system.

The existing wearable continues to provide live posture information through BLE.

12. Readiness Decision

For the Round 2 prototype demonstration, the application uses a 15° readiness threshold.

Conceptually:

Posture deviation ≤ 15°
        │
        ▼
      READY
Posture deviation > 15°
        │
        ▼
CONFLICT DETECTED

The threshold is used as the prototype readiness condition for the demonstration.

13. Why This Addresses the Round 2 Task

The implementation addresses the Round 2 requirement by introducing a decision layer before an activity starts.

Instead of only monitoring posture continuously, Postura first asks:

Is the user ready to begin the activity from a posture perspective?

If the answer is no, the application identifies the conflict and requires the user to correct their posture.

Only after the posture satisfies the readiness condition does the application allow the activity to proceed.

This makes the system preventive rather than purely reactive.

14. Hardware–Software Integration

The workflow demonstrates integration between the physical wearable and the software application.

MPU6050
   │
   ▼
ESP32
   │
   │ BLE
   ▼
Postura App
   │
   ▼
Readiness Evaluation
   │
   ├── Conflict Detected
   │
   └── Ready
          │
          ▼
     Activity Started

The wearable provides the live sensing layer while the application provides the readiness evaluation and user interaction layer.

15. Demo Evidence

The Round 2 demonstration is supported by the following screenshots:

Step	Evidence
BLE Connection	ble-connected.jpeg
Readiness Check	readiness-check.jpeg
Conflict Detected	conflict.jpeg
Posture Corrected	corrected.jpeg
Ready	ready.jpeg
Activity Started	started.jpeg
16. Expected Demo Sequence

For judges evaluating the prototype, the recommended demonstration sequence is:

1. Connect the wearable

Show the Postura application connected to the physical wearable through BLE.

2. Start Readiness Check

Initiate the readiness check from the application.

3. Demonstrate an unsuitable posture

Keep the posture outside the configured readiness condition.

The application should display:

Conflict Detected

4. Correct the posture

The user changes to a suitable posture.

5. Re-evaluate

The application evaluates the updated live posture.

6. Show Ready state

Once the condition is satisfied, the application displays:

Ready

7. Start the activity

The user can now start the intended activity/session.

17. Key Round 2 Contribution

The main contribution of the Round 2 implementation is the addition of a pre-activity posture readiness gate.

The system does not simply detect poor posture after an activity has started.

Instead, it introduces an additional decision point:

Is the user ready to begin?

This connects real-time sensing with application-level decision making and user interaction.

18. Scope of the Prototype

The Round 2 implementation is a prototype demonstration of the readiness and conflict-detection workflow.

The existing physical sensing system provides the live posture data.

The Round 2 application layer evaluates that data before activity initiation and controls the readiness state shown to the user.

The prototype is intended to demonstrate the complete hardware-to-software workflow rather than represent a final clinical or medical decision system.

19. Final Demo State

The successful Round 2 flow is:

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

This demonstrates the complete Postura Round 2 readiness workflow from live wearable sensing to application-level decision and activity initiation.
