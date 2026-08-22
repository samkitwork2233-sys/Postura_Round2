# Postura — Round 2 Demo

## 1. Demo Overview

This document explains how to evaluate the Round 2 **Readiness Check / Conflict Detection** workflow demonstrated by Postura.

The demonstration connects the physical Postura wearable with the companion application and shows how live posture information is used to determine whether the user is ready to begin an activity.

### Demonstration Components

- Postura wearable
- ESP32 microcontroller
- MPU6050 IMU sensor
- Bluetooth Low Energy (BLE)
- Flutter application
- Readiness Check
- Conflict Detection
- Activity Start control

---

## 2. Problem Addressed

Users may begin activities while already maintaining an unsuitable posture.

Postura introduces a readiness layer before an activity begins.

Instead of allowing the user to immediately start an activity, the application first evaluates the current posture state.

If a posture conflict is detected, the user is informed and can correct their posture before proceeding.

---

## 3. Round 2 Workflow

The complete demonstration follows this sequence:

```text
BLE Connection
      |
      v
Readiness Check
      |
      v
Evaluate Live Posture
      |
      +----------------------+
      |                      |
      v                      v
   READY                  CONFLICT
      |                      |
      |                      v
      |               Correct Posture
      |                      |
      |                      v
      |                 Check Again
      |                      |
      +----------+-----------+
                 |
                 v
         Activity Started
4. Step 1 — BLE Connected

The Postura application first establishes a Bluetooth Low Energy connection with the physical wearable.

The wearable provides live posture information to the application through BLE.

Evidence

Screenshot: ble-connected.jpeg

5. Step 2 — Readiness Check

Before beginning the activity, the user initiates the Readiness Check.

At this stage, the application evaluates the current live posture state received from the wearable.

Evidence

Screenshot: readiness-check.jpeg

6. Step 3 — Conflict Detected

If the current posture does not satisfy the configured readiness condition, the application detects a conflict.

For the Round 2 prototype demonstration, the application uses a 15° readiness threshold.

The conflict is presented to the user before the activity begins.

Evidence

Screenshot: conflict.jpeg

7. Step 4 — Posture Corrected

After the conflict is detected, the user corrects their posture.

The application can then evaluate the updated posture state.

Evidence

Screenshot: corrected.jpeg

8. Step 5 — Ready

Once the posture satisfies the readiness condition, the conflict is resolved.

The application indicates that the user is ready to proceed.

Evidence

Screenshot: ready.jpeg

9. Step 6 — Activity Started

After the readiness condition is satisfied, the user can start the intended activity or session.

This completes the Round 2 readiness workflow.

Evidence

Screenshot: started.jpeg

10. Hardware-to-Software Flow

The demonstrated system connects the physical sensing layer to the application-level readiness decision.

        MPU6050 IMU
             |
             v
           ESP32
             |
             v
        BLE Transmission
             |
             v
     Flutter Application
             |
             v
      Live Posture Data
             |
             v
       Readiness Check
             |
             v
    Conflict Detection
             |
       +-----+-----+
       |           |
       v           v
   Conflict      Ready
       |           |
       v           |
 Correct Posture   |
       |           |
       +-----+-----+
             |
             v
      Activity Started
11. Round 2 Contribution

The key Round 2 contribution is the application-level Readiness Check / Conflict Detection layer.

The system does not simply monitor posture continuously.

It introduces a decision point before an activity begins:

Current Posture
       |
       v
Readiness Evaluation
       |
       v
Is posture acceptable?
       |
   +---+---+
   |       |
  YES      NO
   |       |
   v       v
 READY   CONFLICT
   |       |
   |       v
   |   Correct Posture
   |       |
   |       v
   +--- Check Again
           |
           v
         READY
12. Prototype Configuration

The Round 2 demonstration uses the following prototype configuration:

Parameter	Configuration
Posture sensor	MPU6050
Microcontroller	ESP32
Communication	Bluetooth Low Energy
Application	Flutter
Readiness threshold	15°
Decision layer	Application
Feedback	Application readiness/conflict state

The 15° threshold is an application-level prototype parameter used for the Round 2 demonstration. It is not presented as a clinically validated universal threshold.

13. Demonstration Evidence

The following screenshots provide evidence for each stage:

Stage	Evidence
BLE Connection	ble-connected.jpeg
Readiness Check	readiness-check.jpeg
Conflict Detected	conflict.jpeg
Posture Corrected	corrected.jpeg
Ready	ready.jpeg
Activity Started	started.jpeg

All screenshot evidence is available in:

round-2/demo/screenshots/
14. Evaluation Flow for Judges

A judge can evaluate the demonstration in the following order:

Open the Postura application.
Connect the Postura wearable through BLE.
Initiate the Readiness Check.
Observe the current posture evaluation.
Introduce or observe a posture conflict.
Verify that the application detects the conflict.
Correct the posture.
Verify that the conflict is resolved.
Confirm the Ready state.
Start the activity.
15. Prototype Scope

The Round 2 implementation focuses specifically on the Readiness Check / Conflict Detection layer.

The readiness logic is implemented at the application level using the live posture information received from the existing Postura wearable.

The existing embedded sensing system provides the posture data, while the application is responsible for the readiness decision and user-facing workflow.

16. Summary

Postura's Round 2 demonstration shows how a wearable posture-sensing system can be extended beyond passive monitoring.

The system introduces a readiness checkpoint before an activity begins:

SENSE
  ↓
EVALUATE
  ↓
DETECT CONFLICT
  ↓
CORRECT
  ↓
CONFIRM READY
  ↓
START ACTIVITY

This creates a clear interaction between the physical sensing system and the software decision layer.
