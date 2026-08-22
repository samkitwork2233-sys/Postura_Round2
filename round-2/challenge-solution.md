# Postura — Round 2 Challenge Solution

## 1. Problem

Posture-related problems can develop when users repeatedly maintain an unsuitable posture during daily activities.

Most posture-monitoring systems focus on detecting poor posture while the user is already performing an activity.

Postura introduces an additional step:

**checking posture readiness before the activity begins.**

This creates an opportunity to identify a posture conflict before the user starts the intended activity or session.

---

## 2. Our Solution

Postura is a wearable posture-monitoring system combining:

- MPU6050 IMU sensing
- ESP32 embedded processing
- Bluetooth Low Energy (BLE)
- Physical vibration feedback
- Flutter mobile application
- Real-time posture evaluation

For Round 2, the existing posture sensing pipeline is extended with an application-level:

**Readiness Check / Conflict Detection layer.**

The application evaluates the user's current live posture before allowing an activity or session to begin.

---

## 3. Round 2 Workflow

The implemented workflow is:

```text
Wearable
   │
   ▼
MPU6050 Posture Sensing
   │
   ▼
ESP32 Processing
   │
   ▼
BLE Transmission
   │
   ▼
Postura Application
   │
   ▼
Readiness Check
   │
   ▼
Posture Evaluation
   │
   ├───────────────┐
   │               │
 Conflict         Ready
 Detected           │
   │               │
   ▼               ▼
Correct          Activity
Posture           Started
   │
   ▼
Re-evaluate
   │
   └──────────────► Ready
4. Readiness Check

Before starting an activity or session, the application evaluates the user's current posture.

The readiness check uses the live posture information received from the wearable.

For the Round 2 prototype demonstration, a 15° readiness threshold is used.

The decision can be represented as:

Posture deviation ≤ 15°
        │
        ▼
      READY
Posture deviation > 15°
        │
        ▼
CONFLICT DETECTED

The threshold is a prototype parameter used for the Round 2 demonstration.

5. Conflict Detection

When the user's current posture does not satisfy the readiness condition, Postura displays a Conflict Detected state.

The conflict is presented before the activity begins.

This gives the user an opportunity to correct their posture before proceeding.

The system therefore follows:

Detect → Inform → Correct → Re-evaluate

6. Posture Correction

After a conflict is detected, the user corrects their posture.

The application then evaluates the updated live posture state.

If the posture now satisfies the readiness condition, the application changes the state to:

Ready

This creates a closed feedback loop between sensing, software evaluation, and user action.

7. Activity Gate

The readiness state acts as a gate before activity initiation.

The intended flow is:

Readiness Check
      │
      ▼
Posture Suitable?
   │          │
  NO         YES
   │          │
   ▼          ▼
Conflict     Ready
   │          │
   ▼          ▼
Correction  Activity
   │         Starts
   └──► Re-evaluate

The activity is therefore started only after the readiness condition has been satisfied.

8. Hardware Implementation

The wearable hardware contains the major sensing, processing, communication, power, and feedback components required by the system.

Major Components
ESP32 microcontroller
MPU6050 IMU sensor
Vibration motor
Battery and charging circuitry
Power management circuitry
USB interface
Status indicators
Supporting passive components

The hardware design is documented separately in:

hardware/

The repository contains the KiCad schematic design and visual PCB design evidence.

9. Software Implementation

The Postura application provides the software layer required for the Round 2 workflow.

The application handles:

BLE communication
Live posture data
Readiness Check
Conflict Detection
Posture correction state
Ready state
Activity/session initiation

The application provides the user interface through which the complete workflow can be demonstrated.

10. Hardware–Software Integration

The solution combines physical sensing with application-level decision making.

       PHYSICAL LAYER
       
      MPU6050 IMU
           │
           ▼
         ESP32
           │
           │ BLE
           ▼
      SOFTWARE LAYER
           
      Postura App
           │
           ▼
    Readiness Evaluation
           │
      ┌────┴────┐
      │         │
   Conflict    Ready
      │         │
      ▼         ▼
 Correction  Activity
      │        Start
      └───► Re-evaluate

This integration allows the physical wearable to provide live sensing while the application performs the Round 2 readiness evaluation.

11. Technical Depth

The solution combines multiple technical layers:

Embedded System
IMU-based posture sensing
ESP32 processing
Embedded control
Physical feedback
Wireless Communication
Bluetooth Low Energy
Wearable-to-application data transfer
Mobile Software
Flutter application
BLE communication
Real-time state handling
Readiness evaluation
User interface
Hardware Design
KiCad schematic
Component integration
Power management
PCB-level design

The project therefore spans both hardware and software rather than solving the problem using only a single application layer.

12. Innovation

The Round 2 contribution is not limited to detecting poor posture.

Postura introduces a pre-activity readiness concept.

Instead of:

Activity
   ↓
Poor Posture
   ↓
Alert

the Round 2 workflow introduces:

Readiness Check
       ↓
Posture Conflict?
    ↓       ↓
   YES      NO
    ↓        ↓
Correct    Ready
Posture      ↓
    ↓      Activity
Re-check    Starts

This changes the interaction from purely reactive monitoring toward a preventive pre-activity check.

13. Functionality

The demonstrated Round 2 flow supports:

BLE connection
Live posture data
Readiness Check
Conflict Detection
User posture correction
Re-evaluation
Ready state
Activity initiation

The complete workflow is demonstrated through the screenshots and demo documentation in:

round-2/demo/
14. Reliability Considerations

The Round 2 prototype keeps the decision flow simple and observable.

The application exposes distinct states:

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

This makes the system behavior easy to understand and demonstrate.

The readiness threshold is also explicitly defined for the prototype rather than being presented as a clinical standard.

15. Scalability

The readiness architecture can be extended in future versions.

Possible extensions include:

User-specific calibration
Multiple activity profiles
Adjustable readiness thresholds
Historical posture analysis
Personalized posture recommendations
Session analytics
Doctor/rehabilitation dashboards
Institutional monitoring
Additional wearable sensors

The current Round 2 implementation focuses on demonstrating the core readiness and conflict-detection workflow.

16. Documentation

The repository contains supporting documentation for the project.

Application
app/
Hardware
hardware/
Demo
round-2/demo/
Research
docs/research.md
System Architecture
docs/system-architecture.md
Firmware
firmware/
Screenshots
round-2/demo/screenshots/
17. Round 2 Demonstration Evidence

The complete demonstration contains the following stages:

Stage	Evidence
BLE Connected	ble-connected.jpeg
Readiness Check	readiness-check.jpeg
Conflict Detected	conflict.jpeg
Posture Corrected	corrected.jpeg
Ready	ready.jpeg
Activity Started	started.jpeg

Detailed demonstration instructions are available in:

round-2/demo/demo-link.md
18. Alignment With Judging Parameters
Task Implementation

Postura directly implements a pre-activity readiness and conflict-detection workflow using live posture data from the wearable.

Task Complexity

The solution combines embedded sensing, wireless communication, mobile software, posture evaluation, physical feedback, and hardware design.

Technical Execution

The system integrates an MPU6050 IMU, ESP32, BLE communication, and Flutter application logic.

Innovation & Creativity

The Round 2 feature introduces a posture readiness gate before an activity begins rather than relying only on post-activity or continuous alerts.

Functionality & Reliability

The workflow provides observable states from BLE connection through readiness evaluation and activity initiation.

Documentation & Presentation

The repository contains dedicated documentation, hardware design files, system architecture, research material, demo instructions, and screenshot evidence.

19. Final Solution

Postura combines a wearable sensing system with an application-level readiness layer.

The Round 2 solution can be summarized as:

SENSE
  ↓
TRANSMIT
  ↓
EVALUATE
  ↓
DETECT CONFLICT
  ↓
CORRECT
  ↓
RE-EVALUATE
  ↓
READY
  ↓
START ACTIVITY

The key Round 2 contribution is the ability to evaluate posture before an activity begins, creating a preventive readiness checkpoint between real-world sensing and activity initiation.

20. Prototype Scope

This implementation is a prototype demonstration of the Postura readiness workflow.

The 15° threshold is a prototype configuration for the Round 2 demonstration and should not be interpreted as a universal medical or clinical threshold.

Further validation with larger datasets, different users, activities, and clinical/ergonomic expertise would be required before making medical or clinical claims.
