# Postura — Hardware Implementation

## Overview

Postura is a wearable posture-monitoring system that combines inertial sensing, embedded processing, Bluetooth Low Energy (BLE), physical feedback, and a companion application.

The hardware layer captures posture-related motion using an MPU6050 IMU, processes the sensor information using an ESP32, provides physical feedback through a vibration motor, and communicates with the Postura application through BLE.

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
                      | Sensor Data
                      v
                +-----------+
                |   ESP32   |
                | Processing|
                |    + BLE  |
                +--+-----+--+
                   |     |
                   |     | BLE
                   v     v
            +---------+  +-------------+
            |Vibration|  | Postura App |
            |  Motor  |  |             |
            +---------+  +-------------+
Main Hardware Components
Component	Function
ESP32	Main microcontroller, sensor processing and BLE communication
MPU6050	Inertial measurement unit for posture sensing
Vibration Motor	Physical feedback to the wearer
LED Indicators	Device status indication
Rechargeable Battery	Portable power source
Charging Circuit	Battery charging and power management
Custom PCB	Hardware integration and compact board-level implementation
MPU6050 — Posture Sensing

The MPU6050 is the primary sensing component of the Postura wearable.

It combines:

3-axis accelerometer
3-axis gyroscope

The sensor provides inertial measurements that can be processed to estimate the orientation and posture-related angle of the wearable.

The sensing pipeline is:

User Movement
      |
      v
   MPU6050
      |
      v
Acceleration + Gyroscope Data
      |
      v
     ESP32
      |
      v
Posture Information
ESP32 — Embedded Controller

The ESP32 acts as the main controller of the wearable.

Its responsibilities include:

Reading the MPU6050
Processing sensor information
Calculating posture-related measurements
Controlling vibration feedback
Controlling status indicators
Providing BLE communication
Sending posture information to the application
Bluetooth Low Energy

The ESP32 communicates with the Postura application through Bluetooth Low Energy.

MPU6050
   |
   v
ESP32
   |
   v
BLE
   |
   v
Flutter Application

This allows the application to receive live information from the physical wearable.

Physical Feedback

The vibration motor provides direct physical feedback to the user.

The general feedback loop is:

Posture
   |
   v
MPU6050
   |
   v
ESP32
   |
   v
Posture Evaluation
   |
   v
Feedback Condition
   |
   v
Vibration
   |
   v
User Corrects Posture

This creates a direct interaction between the user's physical posture and the wearable.

Hardware-to-Software Integration

The hardware provides the physical sensing layer while the application provides the user-facing readiness and conflict-detection workflow.

             HARDWARE

MPU6050
   |
   v
ESP32
   |
   v
Live Posture Information
   |
   v
BLE
   |
   v

             SOFTWARE

Flutter Application
   |
   v
Readiness Check
   |
   v
Conflict Detection
   |
   v
Correction
   |
   v
Re-evaluation
   |
   v
Ready
   |
   v
Activity Starts
PCB Design

The Postura hardware includes a KiCad-based schematic and PCB design.

The design files are provided as editable source files in this repository.

Schematic

The complete KiCad schematic is available here:

schematic/postura-schematic.kicad_sch

PCB

The KiCad PCB design is available here:

pcb/postura-pcb.kicad_pcb

The PCB design contains the component placement and board-level layout corresponding to the hardware system.

Schematic Evidence

The following image provides a visual overview of the electrical design.

The schematic shows the major hardware blocks and their electrical interconnections, including the ESP32, MPU6050, power-management circuitry, USB interface, indicators, and supporting components.

PCB Layout Evidence

The following image shows the current PCB design and component-placement view.

This view provides visual evidence of the board-level component placement and PCB development.

Note: The displayed PCB image represents the current design-development stage. It is not presented as a production-validated industrial PCB.

Hardware Development Flow
Initial Prototype
       |
       v
Sensor Testing
       |
       v
Posture Detection
       |
       v
ESP32 Integration
       |
       v
Vibration Feedback
       |
       v
BLE Integration
       |
       v
PCB Development
       |
       v
Hardware Integration
Round 2 Integration

The Round 2 feature builds on the existing physical sensing system.

The wearable provides live posture information to the application, where it is used during the readiness workflow.

Wearable
    |
    v
Live Posture Information
    |
    v
BLE
    |
    v
Postura Application
    |
    v
Readiness Check
    |
    v
Conflict Detection
    |
    v
Correction
    |
    v
Re-check
    |
    v
Ready
    |
    v
Activity Starts

The Round 2 software therefore operates on information originating from the physical sensing system.

Hardware Status
Area	Status
MPU6050 sensing	Implemented
ESP32 processing	Implemented
BLE communication	Implemented
Vibration feedback	Implemented
LED indicators	Implemented
Rechargeable power	Implemented
Hardware integration	Implemented
KiCad schematic	Documented
KiCad PCB design	Documented
Industrial production validation	Future work
Industrial-Level Development Roadmap

Further development toward production readiness can include:

PCB
Further miniaturization
Routing optimization
Design-for-manufacturing review
Production PCB validation
Assembly optimization
Mechanical Design
Dedicated enclosure
Improved mounting mechanism
Electronics protection
Improved comfort and wearability
Power
Power-consumption optimization
Battery-life characterization
Charging protection validation
Power-management refinement
Reliability
Long-duration testing
Sensor consistency testing
BLE stability testing
Vibration motor reliability testing
Environmental testing

These are future development areas and are not claimed as completed industrial validation.

Repository Hardware Structure
hardware/
│
├── README.md
│
├── schematic/
│   ├── README.md
│   └── postura-schematic.kicad_sch
│
├── pcb/
│   ├── README.md
│   └── postura-pcb.kicad_pcb
│
└── images/
    ├── README.md
    ├── schematic-overview.png
    └── pcb-layout.png
Summary

The Postura hardware combines:

Inertial sensing
Embedded processing
BLE communication
Physical feedback
Portable power
PCB-level hardware integration

The repository includes both the KiCad source files and visual evidence of the current hardware design.

The hardware layer provides the physical sensing foundation for the Postura Round 2 readiness and conflict-detection workflow.


### Then commit it

