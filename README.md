# <img src="/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png" width="40" height="40" style="border-radius: 50%; vertical-align: middle;" /> Postura

> **Smart Wearable Posture Monitoring & Ergonomic Habit Correction System**

Postura is a wearable posture-monitoring system designed to help users build and maintain healthy spinal habits. It pairs custom physical hardware with a modern Flutter mobile application over Bluetooth Low Energy (BLE), offering **live posture angle tracking**, **instant on-body haptic feedback**, and **detailed session analytics**.

---

## Overview

Poor posture during extended desk work, gaming, or studying contributes to spinal strain, chronic neck/back pain, and fatigue.

**Postura provides continuous ergonomic assistance:**
1. **Dynamic Baseline Calibration**: Calibrates to your natural upright posture at the tap of a button when starting a session.
2. **Continuous Real-Time Tracking**: Continuously monitors angular tilt and deviation from your calibrated baseline.
3. **Instant Dual Feedback**: Triggers both on-body haptic vibration and mobile UI alerts the moment you breach ergonomic limits.
4. **Session Analytics & Scoring**: Evaluates posture consistency, logs slouch frequency, calculates a posture health score, and archives sessions locally.

---

## How It Works

```text
       +-------------------------------------------------------------+
       |                       WEARABLE DEVICE                       |
       |  [ MPU6050 IMU ] -> [ ESP32 Processing ] -> [ Vibration ]   |
       +------------------------------+------------------------------+
                                      |
                                      | BLE Stream (Angle, Deviation)
                                      v
       +-------------------------------------------------------------+
       |                      POSTURA FLUTTER APP                    |
       |                                                             |
       |  1. BLE Connection & Device Discovery                       |
       |  2. Real-Time Gauge & Deviation Visualization               |
       |  3. Active Session Monitoring & Posture Scoring Engine      |
       |  4. Local Session Storage & Historical Insights             |
       +-------------------------------------------------------------+
```

### Complete User Flow
1. **Pair & Connect**: Launch the app and connect to your Postura wearable via Bluetooth Low Energy.
2. **Start Session**: Sit upright and tap **Start Session**—the app automatically calibrates your baseline reference angle and begins tracking.
3. **Live Monitoring**: Work or study comfortably while the app tracks real-time tilt angle, deviation, and session time.
4. **Active Alerts**: If you slouch beyond your custom threshold (e.g. >15°), the wearable vibrates immediately and the app UI switches to alert mode.
5. **Save & Review**: Conclude your session to save the duration, slouch count, and computed posture score into your local history and analytics dashboard.

---

## Hardware Architecture

The Postura wearable is built around an integrated embedded architecture that performs low-latency sensor acquisition and BLE communication.

```text
   +---------------+
   | Lithium LiPo  |
   |    Battery    |
   +-------+-------+
           |
           v
   +---------------+       I2C       +---------------+
   | Power / TP4056| --------------> | MPU6050 6-DoF |
   | Charging Board|                 |  IMU Sensor   |
   +---------------+                 +-------+-------+
           |                                 |
           | 3.3V Power                      | Raw Accelerometer & Gyro
           v                                 v
   +-------------------------------------------------+
   |                 ESP32 Microcontroller           |
   |  - Complementary filter & angle calculation     |
   |  - BLE GATT server (Postura telemetry service)  |
   |  - PWM motor driver control                     |
   +-----------------------+-------------------------+
                           |
            +--------------+--------------+
            |                             |
            v                             v
   +------------------+         +-------------------+
   | Vibration Motor  |         | Status Indicator  |
   | (Haptic Feedback)|         |       LEDs        |
   +------------------+         +-------------------+
```

### Key Hardware Components
| Component | Function |
| :--- | :--- |
| **ESP32 MCU** | Dual-core microcontroller managing sensor polling, angle filtering, BLE GATT server, and motor control. |
| **MPU6050 IMU** | 6-axis inertial measurement unit (3-axis gyroscope + 3-axis accelerometer) capturing spinal tilt and orientation. |
| **Vibration Motor** | Coin-type ERM motor providing discreet on-body haptic feedback during bad posture. |
| **Power & Battery** | Rechargeable LiPo battery with dedicated TP4056 micro-USB / USB-C charging circuitry. |
| **Status LEDs** | Board-level indicators for power, BLE connection status, and charging state. |
| **Custom PCB** | Designed using KiCad for compact wearable form-factor (`hardware/pcb/`). |

### BLE Communication Protocol
- **Device Advertised Name**: `POSTURA_V3`
- **Service UUID**: `12345678-1234-1234-1234-1234567890ab`
- **Characteristic UUID**: `abcd1234-5678-1234-5678-abcdef123456`
- **Data Stream Format**: Transmits live ASCII strings in the format `<angle>,<deviation>` (e.g. `62.5,2.1`).
- **Downlink Commands**:
  - `THRESHOLD:<val>` - Updates the on-device posture slouch tolerance (e.g., `THRESHOLD:15`).
  - `BASE:<val>` - Sends calibrated base reference angle to firmware (e.g., `BASE:60`).

---

## Software Architecture (Flutter Companion App)

The mobile companion application is built with **Flutter & Dart**, focusing on smooth 60fps telemetry rendering, intuitive ergonomic feedback, and offline-first data persistence.

```text
lib/
├── app/
│   ├── history/              # Session history view & detail screens
│   ├── home/                 # Main posture dashboard page
│   ├── insights/             # Weekly/Monthly posture analytics & trends
│   ├── router/               # GoRouter indexed stack navigation
│   └── settings/             # Threshold, theme, & vibration configuration
├── modules/
│   ├── posture/
│   │   ├── actions/          # BLE permissions & connection action handlers
│   │   ├── core/             # Riverpod PostureNotifier & PostureState
│   │   └── services/         # BleService (flutter_blue_plus)
│   └── storage/
│       ├── core/             # History & Settings Riverpod providers
│       ├── models/           # Hive SessionModel entity
│       └── services/         # Hive HistoryService & SharedPreferences
├── shared/
│   ├── components/
│   │   ├── templates/        # Page layout templates & shells
│   │   └── ui/               # GlassCard, PostureGauge, AnimatedButtons
│   └── constants/            # Design tokens, AppColors, AppTheme
└── main.dart                 # App bootstrap & Hive/Settings initialization
```

### Key Software Highlights
- **State Management (Riverpod)**: Unidirectional data flow handling live BLE streams, timer ticks, and posture score computation.
- **Local-First Storage (Hive & SharedPreferences)**: Fast, zero-lag local database storing all previous sessions with zero cloud dependency.
- **Modern Glassmorphism UI**: Polished Material 3 design with dynamic Light/Dark mode support, custom posture radial indicator gauge, and responsive widgets.
- **Data Analytics & Insights**: Interactive chart rendering (`fl_chart`) tracking average posture score, slouch frequency, and total active monitoring time.
- **Granular Customization**: Adjustable slouch angle threshold (5° - 30°) and vibration duration.

---

## Scoring & Posture Evaluation Algorithm

Postura evaluates session quality using both time-in-posture and penalty deductions:

$$\text{Time Score} = \left( \frac{\text{Good Posture Seconds}}{\text{Total Session Seconds}} \right) \times 100$$

$$\text{Final Score} = \operatorname{clamp}\Big( \text{Time Score} - (\text{Slouch Count} \times 2.0), \; 0, \; 100 \Big)$$

- **Good Posture**: Measured deviation is within the configured threshold ($\Delta \le \theta$).
- **Slouch Event**: Triggered when deviation exceeds threshold ($\Delta > \theta$), incrementing the slouch counter and activating alerts.

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.10+ / Dart 3+)
- Android Studio / VS Code with Flutter extensions
- Android device or emulator with Bluetooth 4.2+ (BLE) support

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/Postura_Round2.git
   cd Postura_Round2
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Hive TypeAdapters** (if modifying models):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## Hardware Design Files

All hardware schematics, PCB layouts, and fabrication assets are provided in the [`hardware/`](file:///c:/Users/Prashant%20Bhandari/Documents/Flutter%20Projects/Postura_Round2/hardware) directory:
- [`hardware/schematic/`](file:///c:/Users/Prashant%20Bhandari/Documents/Flutter%20Projects/Postura_Round2/hardware/schematic) — KiCad schematic files (`.kicad_sch`)
- [`hardware/pcb/`](file:///c:/Users/Prashant%20Bhandari/Documents/Flutter%20Projects/Postura_Round2/hardware/pcb) — KiCad PCB layout and routing files (`.kicad_pcb`)
- [`hardware/images/`](file:///c:/Users/Prashant%20Bhandari/Documents/Flutter%20Projects/Postura_Round2/hardware/images) — Rendered board layouts and circuit diagrams

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
