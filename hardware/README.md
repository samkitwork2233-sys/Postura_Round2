# Postura — Hardware Implementation

## Overview

Postura is a wearable posture-monitoring system that combines inertial sensing, embedded processing, Bluetooth Low Energy (BLE), physical haptic feedback, and a companion mobile application.

The hardware layer captures posture-related spinal motion using an MPU6050 IMU, processes the sensor information using an ESP32, provides physical feedback through a vibration motor, and communicates with the Postura mobile application through BLE.

---

## Hardware Architecture

```text
                 USER POSTURE
                      |
                      v
                +-----------+
                |  MPU6050  |
                | IMU Sensor|
                +-----+-----+
                      |
                      | Sensor Data (I2C)
                      v
                +-----------+
                |   ESP32   |
                | Processing|
                |    + BLE  |
                +--+-----+--+
                   |     |
                   |     | BLE Telemetry
                   v     v
            +---------+  +-------------+
            |Vibration|  | Postura App |
            |  Motor  |  |             |
            +---------+  +-------------+
```

### Main Hardware Components

| Component | Function |
| :--- | :--- |
| **ESP32** | Main microcontroller, sensor processing, angle filtering, motor control, and BLE communication |
| **MPU6050** | 6-axis inertial measurement unit (accelerometer + gyro) for posture sensing |
| **Vibration Motor** | Coin-type ERM motor providing immediate physical haptic feedback |
| **LED Indicators** | Power, BLE connection, and charging status indicators |
| **Rechargeable Battery** | 3.7V LiPo portable power source |
| **Charging Circuit** | TP4056-based battery charging and power management with USB interface |
| **Custom PCB** | Integrated hardware implementation and board layout |

---

## MPU6050 — Posture Sensing

The MPU6050 is the primary sensing component of the Postura wearable.

It combines:
- **3-axis accelerometer**: Measures gravitational tilt vectors to establish pitch/roll angles.
- **3-axis gyroscope**: Measures angular velocity for dynamic movement compensation.

The sensing pipeline is:
```text
User Movement -> MPU6050 IMU -> Acceleration + Gyroscope Data -> ESP32 Filter -> Live Posture Angle
```

---

## ESP32 — Embedded Controller

The ESP32 acts as the main controller of the wearable:
- Reads raw data from MPU6050 over I2C at 20–50 Hz.
- Processes sensor information and calculates calibrated posture deviation.
- Controls vibration motor triggers during slouching.
- Hosts the BLE GATT server to stream telemetry and receive threshold/base angle commands.

---

## Physical Feedback Loop

```text
Posture -> MPU6050 -> ESP32 -> Posture Evaluation -> Threshold Exceeded -> Vibration Motor -> User Corrects Posture
```

This creates an immediate on-body feedback loop that trains muscle memory and discourages slouching.

---

## Hardware-to-Software Integration

```text
              HARDWARE
MPU6050 -> ESP32 -> BLE Telemetry
                          |
                          v
              SOFTWARE
Postura Flutter App -> Live Posture Gauge -> Active Session Monitoring -> Session History & Scoring
```

---

## PCB & Schematics Design

The Postura hardware includes complete KiCad-based schematics and PCB layout files:

- **Schematic**: [`schematic/postura-schematic.kicad_sch`](schematic/postura-schematic.kicad_sch)
- **PCB Layout**: [`pcb/postura-pcb.kicad_pcb`](pcb/postura-pcb.kicad_pcb)
- **Visual Assets**: [`images/`](images/)

```text
hardware/
├── README.md
├── schematic/
│   ├── README.md
│   └── postura-schematic.kicad_sch
├── pcb/
│   ├── README.md
│   └── postura-pcb.kicad_pcb
└── images/
    ├── README.md
    ├── schematic-overview.png
    └── pcb-layout.png
```

---

## Summary

The Postura hardware brings together:
- High-precision inertial posture sensing
- Embedded tilt angle filtering on ESP32
- Low-latency BLE telemetry streaming
- Discreet on-body haptic feedback
- Compact rechargeable wearable PCB design
