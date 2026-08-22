# Postura

## Wearable Posture Monitoring + Operational Readiness Conflict Check

Postura is a wearable posture-monitoring system that combines physical sensing, embedded processing, Bluetooth Low Energy (BLE), physical feedback, and a Flutter companion application.

For FAR AWAY 2026 — Round 2, Postura extends its existing wearable system with a **Readiness Check / Conflict Detection** layer.

The system evaluates the user's live posture before an activity or session begins. If the current posture does not satisfy the readiness condition, the application presents a conflict, asks the user to correct their posture, and re-checks the condition before allowing the activity to proceed.

---

# FAR AWAY 2026 — Round 2

## Challenge #728 — Operational Readiness: Conflict Check

The Round 2 challenge focuses on readiness before a major action or launch point, detecting conflicts early, presenting them before the user commits to the action, and demonstrating a complete user flow.

### How Postura addresses the challenge

```text
User wants to start an activity
              |
              v
       Readiness Check
              |
              v
      Read live posture data
              |
              v
       Evaluate condition
              |
        +-----+-----+
        |           |
        v           v
   No Conflict    Conflict
        |           |
        v           v
      READY     Conflict Detected
        |           |
        |           v
        |      Correct Posture
        |           |
        |           v
        |      Check Again
        |           |
        +-----+-----+
              |
              v
       Activity Starts

The key Round 2 behaviour is that the conflict is surfaced before the activity or session begins.

The Problem

A user may begin a prolonged activity without realizing that their current posture is already unsuitable.

Conventional posture monitoring is generally reactive: the system detects poor posture after the activity has already started.

Postura introduces another intervention point:

Check readiness before the action begins.

This allows the system to identify a posture conflict before the user commits to the activity.

Our Solution

Postura combines:

Wearable posture sensing
MPU6050 inertial sensing
ESP32 embedded processing
Bluetooth Low Energy
Vibration feedback
LED status indication
Flutter application
Readiness checking
Conflict detection
User correction
Re-evaluation

The wearable provides the physical posture measurement.

The application converts that live measurement into an operational readiness decision.

Round 2 Feature
Readiness Check / Conflict Detection

Before starting an activity or session, the user performs a readiness check.

The application evaluates the live posture information received from the wearable through BLE.

Prototype readiness parameter
Readiness threshold = 15°

The 15° value is an application-level prototype parameter used for the Round 2 demonstration.

It is not presented as a clinically validated universal medical threshold.

No Conflict
Live posture
     |
     v
Readiness condition satisfied
     |
     v
No Conflict
     |
     v
READY
     |
     v
Activity Starts
Conflict Detected
Live posture
     |
     v
Readiness condition not satisfied
     |
     v
CONFLICT DETECTED
     |
     v
User corrects posture
     |
     v
Readiness checked again
     |
     v
READY
     |
     v
Activity Starts
Complete User Flow
1. Connect

The user connects the Postura wearable to the application through BLE.

2. Prepare

The user chooses to start an activity or session.

3. Readiness Check

The application evaluates the live posture state.

4. Conflict Detection

If the readiness condition is not satisfied, the application presents the conflict before the activity begins.

5. Correction

The user corrects their posture.

6. Re-evaluation

The application evaluates the updated live posture information.

7. Proceed

Once the conflict is resolved, the activity or session can begin.

System Architecture
                    USER
                      |
                      | Posture
                      v
               +-------------+
               |   MPU6050   |
               |  IMU Sensor |
               +------+------+
                      |
                      v
               +-------------+
               |    ESP32    |
               |  Processing |
               |    + BLE    |
               +------+------+
                      |
                      | BLE
                      v
               +-------------+
               | POSTURA APP |
               |   Flutter   |
               +------+------+
                      |
                      v
              +------------------+
              | Readiness Check  |
              +--------+---------+
                       |
                       v
                +-------------+
                |  Conflict?  |
                +------+------+ 
                       |
                 +-----+-----+
                 |           |
                 v           v
            No Conflict   Conflict
                 |           |
                 v           v
               READY     Correction
                 |           |
                 |           v
                 |      Check Again
                 |           |
                 +-----+-----+
                       |
                       v
                 START ACTIVITY
Hardware

The current wearable prototype includes:

Component	Purpose
ESP32	Embedded processing and BLE
MPU6050	Inertial posture sensing
Vibration motor	Physical feedback
LEDs	Status indication
Rechargeable battery	Portable power
Charging circuitry	Battery charging

The hardware design and visual evidence are documented separately.

See:

Hardware Documentation

Software

The application layer uses:

Flutter
Dart
Bluetooth Low Energy
Android/iOS application framework

The application communicates with the ESP32 wearable using BLE.

Firmware and Application Responsibilities
Wearable

The wearable handles:

MPU6050 sensing
Sensor processing
Posture measurement
BLE communication
Physical feedback
Application

The application handles:

BLE connection
Live posture information
Readiness check
Conflict detection
User feedback
Correction workflow
Activity/session initiation

This separation allows the Round 2 readiness feature to operate at the application layer without requiring redesign of the existing wearable sensing architecture.

Why This Is Different

The goal is not simply:

Detect bad posture.

The Round 2 concept is:

Check whether the user is ready before starting the activity.

Reactive approach
Activity starts
      |
      v
Poor posture occurs
      |
      v
System detects it
      |
      v
Alert
Postura Round 2 approach
User prepares to start
      |
      v
Readiness Check
      |
      v
Conflict detected early
      |
      v
User corrects posture
      |
      v
Activity starts

This moves the intervention point before the action begins.

Demo Evidence

The Round 2 demonstration follows this sequence:

01. BLE Connected
       |
       v
02. Readiness Check
       |
       v
03. Conflict Detected
       |
       v
04. Posture Corrected
       |
       v
05. Ready
       |
       v
06. Activity Started

The complete demonstration evidence is available under:

round-2/demo/

The screenshot evidence is available under:

round-2/demo/screenshots/
Hardware Evidence

The repository contains:

hardware/
├── README.md
├── schematic/
├── pcb/
└── images/

The hardware section contains the KiCad schematic, PCB design files, and visual evidence of the current hardware design.

Round 2 Documentation

The main Round 2 documentation is available at:

round-2/challenge-solution.md

Additional documentation is available under:

round-2/docs/
Judging Parameters
Task Implementation

Postura addresses the Round 2 requirement through a readiness and conflict-detection workflow using live posture information before an activity begins.

Task Complexity

The solution combines embedded sensing, IMU data, BLE communication, Flutter application logic, real-time information exchange, and state-based interaction.

Technical Execution

The system integrates a physical wearable with a companion application and creates a communication path between sensing, processing, and the readiness workflow.

Innovation & Creativity

The key concept is to use posture as an activity-readiness condition rather than only displaying a continuous posture measurement.

Functionality & Reliability

The workflow supports:

Readiness checking
Conflict detection
User correction
Re-evaluation
Activity initiation after the conflict is resolved
Documentation & Presentation

The repository includes:

Flutter application source code
Hardware source files
KiCad schematic
KiCad PCB design
Hardware visual evidence
Round 2 challenge documentation
System architecture documentation
Research documentation
Demo documentation
Screenshot evidence
Prototype Limitations

The current implementation is a prototype demonstration.

Postura does not claim to:

Diagnose medical conditions
Clinically assess spinal health
Predict individual injury
Establish a universal medical posture threshold

The 15° value is a prototype application parameter used for the Round 2 readiness demonstration.

Further validation would be required for clinical or population-level claims.

Future Development

Potential future improvements include:

Personalized readiness thresholds
Activity-specific posture targets
Adaptive posture baselines
More advanced sensor fusion
Improved battery efficiency
Smaller wearable PCB
Long-term posture analytics
Clinician validation
Larger user studies
Personalized feedback
Production-level hardware validation

These are future development areas and are not claimed as completed functionality.

Repository Structure
Postura_Round2/
│
├── android/
├── ios/
├── lib/
├── web/
├── windows/
│
├── hardware/
│   ├── README.md
│   ├── schematic/
│   ├── pcb/
│   └── images/
│
├── round-2/
│   ├── challenge-solution.md
│   ├── demo/
│   │   ├── demo-link.md
│   │   └── screenshots/
│   │       ├── README.md
│   │       ├── 01-ble-connected.png
│   │       ├── 02-readiness-check.png
│   │       ├── 03-conflict-detected.png
│   │       ├── 04-posture-corrected.png
│   │       ├── 05-ready.png
│   │       └── 06-activity-started.png
│   │
│   └── docs/
│       ├── research.md
│       └── system-architecture.md
│
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
├── devtools_options.yaml
└── README.md
Project Status
FAR AWAY 2026 — Round 2 Prototype
Feature	Status
Wearable posture sensing	Implemented
MPU6050 integration	Implemented
ESP32 processing	Implemented
BLE communication	Implemented
Flutter application	Implemented
Readiness Check	Implemented
Conflict Detection	Implemented
Correction / Re-check workflow	Implemented
Hardware documentation	Completed
Round 2 documentation	Completed
Screenshot evidence	Completed
Final demonstration	Documented
Conclusion

Postura combines a physical posture-monitoring wearable with a software-based readiness and conflict-detection layer.

The Round 2 workflow changes the interaction from passive monitoring to an active decision process:

Sense
  |
  v
Evaluate
  |
  v
Detect Conflict
  |
  v
Correct
  |
  v
Re-evaluate
  |
  v
Ready
  |
  v
Activity

The result is a focused prototype demonstrating how live physical sensing can be converted into an operational readiness decision before an activity begins.

Team

Samkitwork2233 Team

FAR AWAY 2026 — Round 2

Challenge #728 — Operational Readiness: Conflict Check




```text
Finalize root README for Round 2 submission
