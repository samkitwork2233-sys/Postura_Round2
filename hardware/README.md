# Postura — Hardware Implementation

## Overview

Postura is a wearable posture-monitoring system that combines inertial sensing, embedded processing, Bluetooth Low Energy (BLE), physical feedback, and a companion application.

The hardware is designed to capture the user's posture information using an IMU sensor, process the sensor data using an ESP32, provide local feedback through a vibration motor, and transmit relevant posture information to the Postura application through BLE.

The hardware forms the physical sensing layer of the complete Postura system.

---

## Hardware Architecture

```text
                    USER POSTURE
                         |
                         v
                  +-------------+
                  |   MPU6050   |
                  |  IMU Sensor |
                  +------+------+
                         |
                         | Sensor Data
                         v
                  +-------------+
                  |    ESP32    |
                  |             |
                  | Processing  |
                  | BLE         |
                  | Control     |
                  +---+-----+---+
                      |     |
              Feedback     | BLE
                      |     |
                      v     v
               +--------+  +--------------+
               |Vibration|  | Postura App  |
               |  Motor  |  |              |
               +--------+  +--------------+
1. Main Hardware Components
Component	Function
ESP32	Main microcontroller, sensor processing and BLE communication
MPU6050	Inertial measurement unit used for posture sensing
Vibration Motor	Provides physical feedback to the user
LED Indicators	Provides device status indication
Rechargeable Battery	Portable power source
Charging Circuit	Provides battery charging functionality
Custom PCB	Integrates the electronic components into a compact hardware platform
2. MPU6050 — Posture Sensing

The MPU6050 is the primary sensing component of the Postura wearable.

It combines:

3-axis accelerometer
3-axis gyroscope

The sensor provides inertial measurements that can be processed to estimate the posture angle of the wearable.

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
Posture Angle

The sensor is positioned on the wearable so that its orientation changes with the user's upper-back posture.

3. ESP32 — Embedded Controller

The ESP32 acts as the main controller of the Postura hardware.

Its responsibilities include:

Reading data from the MPU6050
Processing sensor information
Calculating posture-related measurements
Evaluating posture conditions
Controlling vibration feedback
Controlling status indicators
Providing Bluetooth Low Energy communication with the application

The ESP32 provides the connection between the physical sensing layer and the software layer.

4. Bluetooth Low Energy Communication

The ESP32 communicates with the Postura application using Bluetooth Low Energy.

The communication pipeline is:

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

This allows live posture information from the wearable to be made available to the application.

The BLE connection also acts as the communication bridge for the Round 2 readiness workflow.

5. Physical Feedback

Postura includes a vibration motor for immediate physical feedback.

When the system detects a posture condition requiring correction, the vibration mechanism can be activated to notify the wearer.

The feedback loop is:

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
Condition Detected
   |
   v
Vibration Feedback
   |
   v
User Corrects Posture

This creates a direct interaction between the user's physical posture and the wearable device.

6. LED Status Indicators

LED indicators are used to provide simple visual feedback from the wearable.

Depending on the firmware state, LEDs can indicate conditions such as:

Calibration
Normal posture
Posture requiring correction
Device status

The exact indication depends on the firmware implementation used in the prototype.

7. Power System

The wearable is designed around rechargeable portable power.

The power subsystem supplies the required power to:

ESP32
MPU6050
LED indicators
Vibration motor
Supporting circuitry

The system also includes charging circuitry to support rechargeable operation.

The power design is an important part of the wearable implementation because the device is intended to operate independently of a desktop or external power source during normal use.

8. Custom PCB

The Postura hardware development includes custom PCB design for integrating the wearable electronics.

The PCB development focuses on:

Component placement
Electrical connectivity
Power distribution
Sensor integration
ESP32 integration
Feedback circuitry
Compact form factor
Routing
Hardware integration

The PCB is intended to reduce the size and complexity associated with a breadboard-based prototype and provide a more integrated wearable hardware platform.

9. PCB Design Considerations

The PCB design considers the requirements of a wearable device.

Component Placement

Components are positioned to:

Keep the board compact
Maintain practical sensor placement
Reduce unnecessary wiring
Improve overall integration
Power Routing

Power connections are designed to provide appropriate supply paths to the controller, sensor, and feedback circuitry.

Sensor Integration

The MPU6050 requires appropriate placement and orientation because its measurements depend on the physical orientation of the wearable.

Feedback Integration

The vibration motor is integrated as part of the user-feedback mechanism.

Wearable Form Factor

The PCB is being developed with miniaturization and practical wearable integration as important goals.

10. Hardware Development Flow

The hardware development progressed through multiple stages.

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
Hardware Miniaturization
       |
       v
Custom PCB Development
       |
       v
Wearable Integration

This progression allowed the sensing and feedback functionality to be tested before moving toward a more integrated hardware implementation.

11. Hardware and Software Integration

The physical wearable and the Postura application operate as one connected system.

+---------------------------------+
|          POSTURA WEARABLE       |
|                                 |
|  MPU6050                        |
|     |                           |
|     v                           |
|  ESP32 -------> Vibration Motor|
|     |                           |
|     | BLE                       |
+-----|---------------------------+
      |
      v
+---------------------------------+
|          POSTURA APP            |
|                                 |
|  Live Posture Information       |
|  Readiness Check                |
|  Conflict Detection             |
|  User Feedback                  |
|  Activity / Session Workflow    |
+---------------------------------+
12. Round 2 Hardware-to-Software Integration

The Round 2 feature builds on the existing physical sensing system.

The wearable provides live posture information to the application.

The application then uses this information during the readiness workflow.

Wearable
    |
    v
Live Posture Information
    |
    v
BLE
    |
    v
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
Re-check
    |
    v
Ready
    |
    v
Activity Starts

This means that the Round 2 workflow is connected to an actual physical sensing system rather than being demonstrated only through simulated software input.

13. Relationship Between Hardware and Round 2

The hardware provides the physical sensing foundation.

The application adds the operational-readiness layer.

             HARDWARE LAYER

MPU6050
   |
   v
ESP32
   |
   v
Live Posture Data
   |
   v
BLE
   |
   v

          SOFTWARE LAYER

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
Activity

This separation allows the existing sensing hardware to support additional application-level workflows without requiring the core physical sensing system to be redesigned for every new use case.

14. Hardware Evidence

The repository can be used to document the physical implementation through:

PCB design files
Schematic
PCB layout
Component placement
Physical PCB photographs
Wearable prototype photographs
Circuit integration photographs
Hardware/software integration photographs

These artifacts provide evidence for the hardware-related judging parameters.

15. Hardware Quality Considerations

The hardware implementation is evaluated with attention to:

Circuit integration
Component selection
PCB design
Sensor placement
Power design
Physical assembly
Wearability
Compactness
Reliability
Manufacturability

The current prototype represents an engineering development stage, while further refinement can improve production readiness.

16. Industrial-Level Development Roadmap

The current hardware provides a functional prototype platform.

Further development toward an industrial-ready product would include:

PCB
Further miniaturization
Optimized routing
Design-for-manufacturing review
Production PCB validation
Assembly optimization
Mechanical Design
Dedicated enclosure
Improved mounting mechanism
Better protection of electronics
Improved comfort and wearability
Power
Improved power optimization
Battery-life characterization
Charging protection validation
Power-management refinement
Reliability
Long-duration testing
Sensor consistency testing
BLE stability testing
Vibration motor reliability testing
Environmental testing
Production
Component sourcing validation
Assembly process definition
Manufacturing tolerances
Quality-control procedure
Production testing

These are future refinement steps and are not claimed as completed industrial validation.

17. Current Hardware Status
Area	Status
MPU6050 posture sensing	Implemented
ESP32 processing	Implemented
BLE communication	Implemented
Vibration feedback	Implemented
LED indicators	Implemented
Rechargeable power	Implemented
Hardware integration	Implemented
Custom PCB development	Developed
Wearable prototype	Developed
Industrial production validation	Future work
18. Technical Summary

The Postura hardware combines sensing, processing, communication, and feedback into a wearable platform.

+---------------+
|    MPU6050    |
|    Sensing    |
+-------+-------+
        |
        v
+---------------+
|     ESP32     |
|   Processing  |
|     + BLE     |
+---+-------+---+
    |       |
    |       +----------------+
    v                        v
Vibration                    BLE
Feedback                      |
                              v
                       +--------------+
                       | Postura App  |
                       +------+-------+
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
                            Ready
                              |
                              v
                       Activity Starts

The combination of physical sensing and software-based readiness evaluation enables Postura to connect real-world posture information with an operational decision workflow
