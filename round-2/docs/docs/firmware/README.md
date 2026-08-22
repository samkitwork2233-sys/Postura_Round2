# Postura — Firmware Documentation

## 1. Overview

The Postura wearable uses an ESP32-based embedded system to measure posture, process sensor data, provide physical feedback, and communicate posture information to the companion application.

The firmware is responsible for the core wearable functionality.

The Round 2 readiness and conflict-detection workflow is implemented at the application layer and uses the live posture information provided by the wearable.

---

## 2. Hardware Used

The current wearable prototype is based on:

* ESP32 microcontroller
* MPU6050 inertial measurement unit
* Vibration motor
* Status LEDs
* Rechargeable battery
* Battery/charging circuitry

The MPU6050 provides the motion and orientation data required for posture-angle estimation.

---

## 3. Firmware Responsibilities

The embedded firmware performs the following major functions:

### Sensor acquisition

The ESP32 communicates with the MPU6050 and continuously reads inertial measurements.

### Posture processing

The sensor measurements are processed to obtain a posture-angle value used by the wearable's posture-monitoring logic.

### Feedback

When the existing posture-monitoring logic identifies an undesirable posture condition, the wearable can provide physical feedback through the vibration motor and status indicators.

### BLE communication

The ESP32 exposes posture information through Bluetooth Low Energy (BLE), allowing the companion application to receive live posture data.

---

## 4. Firmware Data Flow

```text
        User posture
             ↓
          MPU6050
             ↓
      Sensor measurements
             ↓
           ESP32
             ↓
      Posture processing
             ↓
      ┌──────┴──────┐
      ↓             ↓
Physical feedback   BLE
      ↓             ↓
 Vibration/LED    Postura App
```

---

## 5. BLE Communication

The ESP32 communicates with the Postura application using Bluetooth Low Energy.

The wearable provides a BLE service and characteristic through which posture information can be transmitted to the application.

The application uses this live information for visualization and the Round 2 readiness workflow.

### BLE identifiers

The current prototype uses:

```text
Service UUID:
12345678-1234-1234-1234-1234567890ab

Characteristic UUID:
abcd1234-5678-1234-5678-abcdef123456
```

These identifiers allow the application to discover and communicate with the Postura wearable.

---

## 6. Calibration

The posture-monitoring system uses calibration to establish the user's reference orientation.

Calibration is important because the wearable can be positioned slightly differently for different users or sessions.

The reference orientation provides the baseline from which posture-angle changes can be evaluated.

---

## 7. Physical Feedback

The wearable provides immediate physical feedback when the embedded posture-monitoring logic detects an undesirable posture condition.

The primary feedback mechanism is a vibration motor.

This creates a direct connection between:

```text
Posture deviation
       ↓
ESP32 detection
       ↓
Vibration feedback
       ↓
User correction
```

The application can additionally provide visual and contextual feedback through the user interface.

---

## 8. Relationship With Round 2

The Round 2 feature does not require the existing wearable to perform the complete readiness workflow.

Instead:

```text
┌─────────────────────────────┐
│        WEARABLE             │
│                             │
│ MPU6050 → ESP32 → BLE       │
└─────────────┬───────────────┘
              │
              │ Live posture data
              ▼
┌─────────────────────────────┐
│       POSTURA APP           │
│                             │
│ Readiness Check             │
│       ↓                     │
│ Threshold Evaluation        │
│       ↓                     │
│ Conflict / Ready            │
└─────────────────────────────┘
```

The firmware continues to provide the physical sensing capability while the application determines whether the current posture satisfies the Round 2 readiness condition.

---

## 9. Why the Logic Is Split

Separating sensing from application-level decision logic provides several advantages:

* Existing embedded functionality can remain stable.
* The Round 2 feature can be demonstrated without rewriting the wearable firmware.
* Application behaviour can be updated independently.
* The readiness threshold can be changed without changing the physical sensing architecture.
* The same wearable can potentially support multiple application workflows.

---

## 10. Round 2 Prototype Threshold

The Round 2 application currently uses:

```text
Readiness threshold = 15°
```

This value is an application-level prototype parameter.

It should **not** be interpreted as a medically validated threshold.

The application uses the value to demonstrate the following workflow:

```text
Live angle ≤ 15°
        ↓
Posture acceptable
        ↓
Ready to start


Live angle > 15°
        ↓
Conflict detected
        ↓
User corrects posture
        ↓
Readiness checked again
```

---

## 11. Firmware Scope

The firmware is designed to handle the wearable-side responsibilities:

| Function                 | Firmware |
| ------------------------ | -------- |
| MPU6050 communication    | Yes      |
| Sensor data acquisition  | Yes      |
| Posture-angle processing | Yes      |
| BLE communication        | Yes      |
| Vibration feedback       | Yes      |
| LED/status feedback      | Yes      |
| Round 2 readiness UI     | No       |
| Round 2 conflict screen  | No       |
| Session interface        | No       |

The final three functions are handled by the companion application.

---

## 12. Current Prototype Status

The wearable firmware is treated as the existing sensing platform for the Round 2 demonstration.

The application consumes the live BLE posture data and adds the readiness/conflict layer required for the Round 2 prototype.

This approach minimizes unnecessary changes to the embedded system while demonstrating a meaningful extension at the application level.

---

## 13. Future Firmware Improvements

Future versions could improve the embedded system through:

* Better sensor fusion
* Improved calibration
* Lower power consumption
* More compact PCB integration
* Personalized posture baselines
* Improved BLE reliability
* Additional sensor validation
* Activity-specific posture profiles

These improvements are outside the core scope of the current Round 2 demonstration.
