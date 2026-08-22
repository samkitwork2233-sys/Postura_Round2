# Postura — Round 2 Challenge Solution

## 1. Problem

Poor posture is a common problem during prolonged sitting, studying, working, and other activities that require sustained body positioning.

People often do not recognize that their posture has gradually become incorrect until discomfort or fatigue appears. Traditional posture-monitoring approaches generally focus on detecting poor posture after it has already occurred.

Postura aims to introduce an additional layer: **readiness and conflict detection before starting an activity or session.**

## 2. Our Approach

Postura is a wearable posture-monitoring system consisting of:

* A wearable sensing device
* MPU6050-based posture sensing
* ESP32-based processing and BLE communication
* Vibration-based physical feedback
* A companion mobile application

The wearable continuously provides the user's posture angle to the application through Bluetooth Low Energy (BLE).

## 3. Round 2 Feature — Readiness Check

For Round 2, Postura introduces an application-level **Readiness Check / Conflict Detection** layer.

Before starting an activity or session, the user performs a readiness check.

The application evaluates the current live posture angle received from the wearable.

### Decision Logic

```text
User wants to start activity/session
              ↓
       Readiness Check
              ↓
      Read live posture angle
              ↓
       Compare with threshold
              ↓
      ┌───────┴────────┐
      ↓                ↓
  Acceptable        > Threshold
   posture              ↓
      ↓          Conflict Detected
 Ready to Start          ↓
                  User Corrects Posture
                         ↓
                  Readiness Check Again
                         ↓
                    Ready to Start
```

## 4. Conflict Detection

The prototype uses a posture-angle threshold of **15°** for the Round 2 readiness check.

If the detected posture angle exceeds the threshold:

**Conflict Detected**

is shown to the user instead of immediately allowing the activity/session to begin.

The purpose is not to diagnose a medical condition. It is a preventive interaction layer designed to encourage the user to correct their posture before beginning prolonged activity.

## 5. Why This Matters

Most posture systems focus primarily on detecting and responding to bad posture while the user is already engaged in an activity.

Postura extends this concept by asking:

> "Is the user's posture suitable to begin the activity in the first place?"

This creates a simple intervention point before prolonged sitting, studying, working, or other posture-sensitive activities.

## 6. Hardware–Software Integration

The system is divided into two major layers.

### Wearable Layer

The wearable contains:

* MPU6050 inertial measurement unit
* ESP32 microcontroller
* BLE communication
* Vibration feedback
* Status indicators
* Battery-powered hardware

The wearable measures the user's posture angle and communicates the live measurement to the application.

### Application Layer

The mobile application:

* Connects to the wearable through BLE
* Receives the live posture angle
* Performs the readiness check
* Evaluates the configured threshold
* Detects posture conflict
* Guides the user toward correction
* Allows the session to begin when readiness conditions are satisfied

## 7. Design Principle

The Round 2 implementation intentionally keeps the readiness/conflict detection logic in the application layer.

The existing wearable firmware remains responsible for sensing, processing, BLE communication, and physical feedback.

This allows the Round 2 feature to be demonstrated without requiring changes to the existing packed ESP32 firmware.

## 8. Expected User Flow

1. User wears the Postura device.
2. User connects the device to the application.
3. User chooses to start an activity/session.
4. The application requests a readiness check.
5. The application reads the live posture angle.
6. The posture is compared against the readiness threshold.
7. If the posture is acceptable, the user can proceed.
8. If the posture exceeds the threshold, a conflict is displayed.
9. The user corrects their posture.
10. The application evaluates the posture again.
11. Once the posture is acceptable, the user can start the activity/session.

## 9. Scope of the Round 2 Prototype

The Round 2 implementation focuses specifically on demonstrating the **Readiness Check / Conflict Detection** concept.

It does not claim to provide medical diagnosis or clinical assessment.

The prototype demonstrates how live physical sensing can be converted into an application-level decision before an activity begins.

## 10. Key Innovation

The key idea demonstrated in Round 2 is the transition from:

**"Detect bad posture"**

to:

**"Check posture readiness before starting an activity."**

This creates a preventive interaction rather than relying only on post-event correction.
