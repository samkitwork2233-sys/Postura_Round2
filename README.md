<p align="center">
  <img src="android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png" width="120" height="120" alt="Postura Logo" />
</p>

<h1 align="center">Postura</h1>
<p align="center">Smart Posture Monitoring & Correction</p>

Postura is a state-of-the-art mobile application designed to improve spinal health. It connects to external accelerometer hardware via Bluetooth Low Energy (BLE) to deliver real-time posture deviation alerts, session logging, spinal alignment history, and historical insights.

The interface is built using a custom **Premium Frosted Glassmorphic Design System** that features deep slate radial background glows, translucent card overlays, and vibrant luminous teal gradients.

---

## 🚀 Round 2 Hackathon Extensions (Today's Work)

Today's features extend the MVP to focus on **action readiness, pre-flight posture validation, and hardware synchronization**:

### 1. Pre-Flight Posture Readiness Check
*   **The Problem**: Users starting a posture tracking session without a calibrated upright baseline leading to false slouch alerts.
*   **The Solution**: Implemented a **3-second posture readiness verification flow**. 
*   **How it works**: When a user taps "Start Session", a circular countdown timer starts. The app monitors real-time telemetry from the posture sensor and validates if the angle lies within the user's customized **Ideal Upright Range**.
    *   **Success**: The app triggers a confetti animation, records the base angle, updates the hardware calibration reference, and starts the active session tracking.
    *   **Warning**: If the angle is outside the target range, a "Readiness Warning" is displayed, asking the user to sit straight and try verification again.

### 2. Dynamic Target Upright Range Settings
*   **Interactive Customization**: Added an interactive **Range Slider (0° to 90°)** inside the Settings panel, enabling users to calibrate their custom target posture boundaries based on personal comfort.
*   **Home View Mapping**: These min/max angles map dynamically to the Home screen, showing live validation markers: `(Target: Min° - Max°)`.

### 3. BLE Hardware Synchronization
*   **Dual-Layer Calibration**: Added a hardware sync protocol. The app transmits the calibrated upright angle (`BASE:<angle>`) to the physical posture sensor over Bluetooth.
*   **Firmware Support**: If the hardware firmware supports `BASE:` parser protocols, the physical sensor calibrates its base accelerometer axis; otherwise, the mobile app calculates deviations locally to keep alerts unified.

### 4. UI Overhaul & Glassmorphism Styling
*   **Glow & Radial Background**: Designed radial highlights (luminous teal fading to deep slate `#0D171C`) that act as a dynamic background across all screens.
*   **Gradient Buttons**: Re-styled all primary and destructive buttons with glowing linear gradients (Teal and Rose) and micro-scale animations.
*   **translucent settings Badges**: Replaced clunky text fields with rounded glass badges for Sensitivity and Vibration metrics.
*   **Circle Progress Layers**: Added an inner glass layer inside the posture indicator gauge.

---

## 🛠️ Technology Stack

*   **Framework**: Flutter (Dart)
*   **State Management**: Riverpod (Notifier & State Notifier Providers)
*   **Connectivity**: Bluetooth Low Energy (BLE) via Flutter Blue Plus
*   **Persistence**: SharedPreferences (Local Storage)
*   **Design Archetype**: Frosted Glassmorphism (BackdropFilters, linear gradients, and radial glowing backgrounds)

---

## 📱 Getting Started & Building

### Prerequisites
Make sure you have Flutter installed and configured on your system.

### Install Dependencies
```bash
flutter pub get
```

### Build Release APK
To compile the updated design into a shareable Android package:
```bash
flutter build apk --release
```
The compiled APK will be output to:
`build/app/outputs/flutter-apk/app-release.apk`
