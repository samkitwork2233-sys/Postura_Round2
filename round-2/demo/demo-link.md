# Postura — Round 2 Demo

## 1. Demo Overview

This document explains how to evaluate the Round 2 **Readiness Check / Conflict Detection** workflow demonstrated by Postura.

The demonstration uses:

* Postura wearable
* ESP32
* MPU6050
* Bluetooth Low Energy
* Postura Flutter application

The application receives the live posture angle from the wearable and uses it to determine whether the user is ready to begin an activity/session.

---

## 2. Demonstration Flow

The complete Round 2 flow is:

```text
Wear Postura
     ↓
Connect wearable to app
     ↓
Open readiness check
     ↓
Read live posture angle
     ↓
Compare against 15° threshold
     ↓
 ┌───────────────┐
 │               │
 ▼               ▼
≤ 15°           > 15°
 │               │
 ▼               ▼
READY         CONFLICT
 │               │
 │          Correct posture
 │               │
 │               ▼
 │        Check posture again
 │               │
 └───────┬───────┘
         ▼
   Start activity
```

---

## 3. Test Case 1 — Ready

### Objective

Verify that the application allows the user to proceed when the live posture angle satisfies the readiness condition.

### Procedure

1. Turn on the Postura wearable.
2. Open the Postura application.
3. Connect the wearable using BLE.
4. Wear the device in an acceptable posture.
5. Start the Readiness Check.
6. Observe the live posture angle.
7. If the angle is at or below the prototype threshold of **15°**, the application should indicate that the user is ready.
8. Proceed to start the activity/session.

### Expected Result

```text
Live angle ≤ 15°
       ↓
Posture acceptable
       ↓
Ready
       ↓
Activity/session can begin
```

---

## 4. Test Case 2 — Conflict Detected

### Objective

Verify that the application detects a posture conflict before allowing the activity/session to begin.

### Procedure

1. Connect the Postura wearable to the application.
2. Adopt a posture that produces a live angle above the prototype threshold.
3. Start the Readiness Check.
4. Observe the application response.

### Expected Result

```text
Live angle > 15°
       ↓
Conflict Detected
       ↓
User is prompted to correct posture
```

The application should not immediately proceed to the activity/session while the readiness condition is not satisfied.

---

## 5. Test Case 3 — Correction

### Objective

Verify that the user can resolve a detected conflict.

### Procedure

1. Trigger the Conflict Detected state.
2. Correct the posture.
3. Allow the application to receive the updated live posture angle.
4. Perform the readiness evaluation again.

### Expected Result

```text
Conflict Detected
       ↓
User corrects posture
       ↓
Live angle returns to acceptable range
       ↓
Ready
       ↓
Activity/session can begin
```

---

## 6. What the Judge Should Observe

During the demonstration, the important elements are:

### Physical Layer

The wearable provides real posture data using the MPU6050 and ESP32.

### Communication Layer

The live posture information is transferred from the wearable to the application using BLE.

### Decision Layer

The application evaluates the live posture against the Round 2 readiness threshold.

### User Interaction

The application provides different outcomes:

* **Ready**
* **Conflict Detected**
* **Correction**
* **Ready after correction**

---

## 7. Why This Demonstrates Round 2

The demonstration is not simply showing a posture sensor.

It demonstrates a complete decision loop:

```text
Physical condition
       ↓
Sensor measurement
       ↓
BLE transmission
       ↓
Application evaluation
       ↓
Conflict detection
       ↓
User correction
       ↓
Re-evaluation
       ↓
Activity initiation
```

This demonstrates how real-world physical sensing can influence an application decision before an activity begins.

---

## 8. Prototype Threshold

The current demonstration uses:

**15°**

as the readiness threshold.

This is a prototype application parameter used to demonstrate the Round 2 workflow.

It is **not presented as a clinically validated medical threshold**.

---

## 9. Demo Evidence

The repository should contain screenshots or recordings demonstrating the following states:

```text
01 — BLE connected
02 — Readiness check started
03 — Acceptable posture / Ready
04 — Conflict Detected
05 — User correction
06 — Ready after correction
07 — Activity/session started
```

Screenshots and/or a demonstration video can be added to this directory as the final demo evidence.

---

## 10. Demo Video

### Video

**To be added after the final Round 2 demonstration recording is available.**

Recommended format:

* Short 1–3 minute demonstration
* Show the physical wearable
* Show BLE connection
* Show live posture angle
* Trigger Conflict Detected
* Correct posture
* Show Ready state
* Start the activity/session

### Video Link

`[Add final demo video link here]`

---

## 11. Reproducibility

A judge should be able to understand the demonstration using the following components:

```text
Hardware
   ↓
Postura wearable
   ↓
ESP32 + MPU6050
   ↓
BLE
   ↓
Postura application
   ↓
Readiness Check
   ↓
Conflict Detection
```

The purpose of this documentation is to make the Round 2 demonstration reproducible and understandable without requiring the evaluator to inspect the entire source codebase.
