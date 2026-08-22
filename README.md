# Postura

### Wearable Posture Monitoring + Operational Readiness Conflict Check

Postura is a wearable posture-monitoring system that combines physical sensing, embedded processing, Bluetooth Low Energy (BLE), and a companion application.

For **FAR AWAY 2026 — Round 2, Challenge #728: Operational Readiness: Conflict Check**, Postura extends its existing MVP with a readiness layer that detects a posture conflict **before the user commits to starting an activity or session**.

---

## FAR AWAY 2026 — Round 2

### Challenge #728 — Operational Readiness: Conflict Check

The Round 2 challenge asks teams to extend their MVP with a capability related to readiness before a major action or launch point, detect conflicts early, present them before the user commits to the action, and demonstrate a complete user flow.

### How Postura addresses it

```text
User wants to start an activity
              ↓
        Readiness Check
              ↓
     Read live posture data
              ↓
       Evaluate condition
              ↓
      ┌───────┴────────┐
      ↓                ↓
 No Conflict        Conflict
      ↓                ↓
    READY       Conflict Detected
      ↓                ↓
 Start Activity   Correct Posture
                       ↓
                  Check Again
                       ↓
                     READY
                       ↓
                Start Activity
```

The important Round 2 behaviour is that the conflict is surfaced **before the activity/session begins**.

---

# The Problem

Poor posture and prolonged sitting are relevant ergonomic and musculoskeletal concerns.

Postura is designed around a simple practical problem:

> A user may begin a prolonged activity without realizing that their current posture is already unsuitable.

Traditional reactive feedback can detect an undesirable posture after the activity has already started.

Postura adds another intervention point:

**Check readiness before the action begins.**

---

# Our Solution

Postura combines:

* Wearable posture sensing
* ESP32 embedded processing
* MPU6050 inertial sensing
* Bluetooth Low Energy
* Vibration feedback
* Flutter application
* Readiness checking
* Conflict detection
* User correction and re-evaluation

The wearable provides the physical measurement.

The application converts that measurement into an operational readiness decision.

---

# Round 2 Feature

## Readiness Check / Conflict Detection

Before starting an activity or session, the user performs a readiness check.

The application evaluates the live posture angle received from the wearable.

The current prototype uses:

**15° readiness threshold**

This is an application-level prototype parameter and is **not presented as a clinically validated medical threshold**.

### If posture is acceptable

```text
Live posture
     ↓
Within readiness condition
     ↓
No conflict
     ↓
READY
     ↓
Activity starts
```

### If a conflict is detected

```text
Live posture
     ↓
Readiness condition not satisfied
     ↓
CONFLICT DETECTED
     ↓
User corrects posture
     ↓
Readiness checked again
     ↓
READY
     ↓
Activity starts
```

---

# Complete User Flow

### 1. Connect

The user connects the Postura wearable to the application through BLE.

### 2. Prepare

The user chooses to start an activity/session.

### 3. Readiness Check

The application evaluates the live posture state.

### 4. Conflict Detection

If the readiness condition is not satisfied, the application presents the conflict before the activity starts.

### 5. Correction

The user corrects their posture.

### 6. Re-evaluation

The application checks the updated posture.

### 7. Proceed

Once the conflict is resolved, the activity/session can begin.

---

# System Architecture

```text
                    USER
                     │
                     │ Posture
                     ▼
              ┌─────────────┐
              │   MPU6050   │
              │ IMU Sensor  │
              └──────┬──────┘
                     │
                     ▼
              ┌─────────────┐
              │    ESP32    │
              │ Processing  │
              │ + BLE       │
              └──────┬──────┘
                     │
                     │ BLE
                     ▼
              ┌─────────────┐
              │ POSTURA APP │
              │   Flutter   │
              └──────┬──────┘
                     │
                     ▼
            ┌───────────────────┐
            │  Readiness Check  │
            └─────────┬─────────┘
                      │
                      ▼
              ┌──────────────┐
              │   Conflict?  │
              └──────┬───────┘
                     │
             ┌───────┴────────┐
             ▼                ▼
        No Conflict        Conflict
             │                │
             ▼                ▼
           READY          Correction
             │                │
             │                ▼
             │           Check Again
             │                │
             └───────┬────────┘
                     ▼
               START ACTIVITY
```

---

# Hardware

The current wearable prototype uses:

| Component            | Purpose                   |
| -------------------- | ------------------------- |
| ESP32                | Embedded processing + BLE |
| MPU6050              | Inertial posture sensing  |
| Vibration motor      | Physical feedback         |
| LEDs                 | Status indication         |
| Rechargeable battery | Portable power            |
| Charging circuitry   | Battery charging          |

---

# Software

The application layer uses:

* Flutter
* Dart
* Bluetooth Low Energy
* Android/iOS application framework

The application communicates with the ESP32 wearable using BLE.

---

# Firmware and Application Responsibilities

## Wearable

The wearable handles:

* MPU6050 sensing
* Sensor processing
* Posture measurement
* BLE communication
* Physical feedback

## Application

The application handles:

* BLE connection
* Live posture information
* Readiness check
* Conflict detection
* User feedback
* Correction workflow
* Session/activity initiation

This separation allows the Round 2 feature to be added at the application level without requiring the existing wearable sensing architecture to be redesigned.

---

# Why This Is Different

The goal is not simply:

> **Detect bad posture.**

The Round 2 concept is:

> **Check whether the user is ready before starting the activity.**

### Reactive approach

```text
Activity starts
      ↓
Poor posture occurs
      ↓
System detects it
      ↓
Alert
```

### Postura Round 2 approach

```text
User prepares to start
      ↓
Readiness Check
      ↓
Conflict detected early
      ↓
User corrects posture
      ↓
Activity starts
```

This moves the intervention point **before the commitment/action**.

---

# Demo Evidence

The repository contains evidence for the complete Round 2 flow.

Expected evidence sequence:

1. BLE connected
2. Readiness check
3. Conflict detected
4. Posture corrected
5. Ready state
6. Activity started

See:

[`screenshots/`](screenshots/)

The demonstration documentation is available at:

[`demo/demo-link.md`](demo/demo-link.md)

---

# Documentation

| Document                                                    | Description                         |
| ----------------------------------------------------------- | ----------------------------------- |
| [Round 2 Challenge Solution](round-2/challenge-solution.md) | Problem-to-solution mapping         |
| [System Architecture](docs/system-architecture.md)          | Hardware/software architecture      |
| [Research & Evidence](docs/research.md)                     | Problem evidence and research basis |
| [Firmware Documentation](firmware/README.md)                | Wearable firmware responsibilities  |
| [Demo Documentation](demo/demo-link.md)                     | Complete Round 2 demonstration      |
| [Screenshot Evidence](screenshots/README.md)                | Visual evidence requirements        |

---

Postura/
│
├── app/
│
├── android/
├── ios/
├── lib/
├── web/
├── windows/
│
├── demo/
│   └── demo-link.md
│
├── docs/
│   ├── research.md
│   └── system-architecture.md
│
├── firmware/
│   └── README.md
│
├── round-2/
│   ├── challenge-solution.md
│   └── demo/
│       └── screenshots/
│           ├── README.md
│           ├── ble-connected.jpeg
│           ├── readiness-check.jpeg
│           ├── conflict.jpeg
│           ├── corrected.jpeg
│           ├── ready.jpeg
│           └── started.jpeg
│
├── pubspec.yaml
└── README.md

---

# Prototype Limitations

The current implementation is a prototype demonstration.

Postura does not claim to:

* Diagnose medical conditions
* Clinically assess spinal health
* Predict individual injury
* Establish a universal medical posture threshold

The **15° value is a prototype application parameter** used for the Round 2 readiness demonstration.

Further validation would be required for clinical or population-level claims.

---

# Future Development

Potential future improvements include:

* Personalized readiness thresholds
* Activity-specific thresholds
* Adaptive posture baselines
* More advanced sensor fusion
* Improved battery efficiency
* Smaller wearable PCB
* Long-term posture analytics
* Clinician validation
* Larger user studies
* Personalized feedback

---

# Project Status

### Current Round 2 Prototype

**Core readiness concept:** Implemented

**Live wearable data:** Implemented

**BLE communication:** Implemented

**Readiness check:** Implemented

**Conflict detection:** Implemented

**Correction/re-check workflow:** Implemented

**Round 2 documentation:** In progress

**Final demo evidence:** To be finalized

---

# Team

**Samkitwork2233**

FAR AWAY 2026 — Round 2

**Challenge #728 — Operational Readiness: Conflict Check**
