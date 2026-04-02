import 'package:vibration/vibration.dart';
import '../../modules/storage/services/settings_service.dart';

class AlertService {
  final SettingsService _settingsService;

  AlertService(this._settingsService);

  Future<void> triggerAlert() async {
    if (await Vibration.hasVibrator()) {
      final duration = _settingsService.vibrationDuration.toInt();
      Vibration.vibrate(duration: duration);
    }
    
    if (_settingsService.soundEnabled) {
      // Logic for sound alert (requires audioplayers or similar)
      // For prototype, we focus on vibration as primary feedback
    }
  }

  void cancelAlerts() {
    Vibration.cancel();
  }
}
