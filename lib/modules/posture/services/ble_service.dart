import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  static const String deviceName = "POSTURA_V3";
  static const String serviceUuid = "12345678-1234-1234-1234-1234567890ab";
  static const String charUuid = "abcd1234-5678-1234-5678-abcdef123456";

  bool useMock = false; // Set to false to use real device
  final StreamController<String> _dataController = StreamController<String>.broadcast();
  final StreamController<BluetoothConnectionState> _connectionStateController = StreamController<BluetoothConnectionState>.broadcast();
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _notifySubscription;
  StreamSubscription? _connectionSubscription;

  String get connectedDeviceName => _device?.platformName ?? "";
  String get connectedDeviceAddress => _device?.remoteId.str ?? "";

  Stream<String> get dataStream => _dataController.stream;
  Stream<BluetoothConnectionState> get connectionState => _connectionStateController.stream;

  Future<bool> connect() async {
    // Bluetooth Adapter Verification
    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      return false; 
    }

    // Start scanning
    try {
      await FlutterBluePlus.startScan(
        withNames: [deviceName],
        timeout: const Duration(seconds: 15),
      );

      // Listen for scan results
      final scanTrigger = Completer<bool>();
      _scanSubscription = FlutterBluePlus.onScanResults.listen((results) async {
        for (ScanResult r in results) {
          if (r.device.platformName == deviceName || 
              r.advertisementData.advName == deviceName ||
              r.advertisementData.serviceUuids.contains(Guid(serviceUuid))) {
            await FlutterBluePlus.stopScan();
            _device = r.device;
            
            // Listen to device connection state
            await _connectionSubscription?.cancel();
            _connectionSubscription = _device!.connectionState.listen((state) {
              _connectionStateController.add(state);
            });

            // Connect to device (Free license for personal use)
            await _device!.connect(license: License.free);
            
            // Setup services
            await _setupServices();
            
            if (!scanTrigger.isCompleted) scanTrigger.complete(true);
            break;
          }
        }
      });

      return await scanTrigger.future.timeout(const Duration(seconds: 20), onTimeout: () => false);
    } catch (e) {
      debugPrint("Connection error: $e");
      return false;
    }
  }

  Future<void> _setupServices() async {
    if (_device == null) return;

    List<BluetoothService> services = await _device!.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid.toString() == serviceUuid) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == charUuid) {
            _characteristic = characteristic;
            
            // Enable notifications
            await _characteristic!.setNotifyValue(true);
            _notifySubscription = _characteristic!.lastValueStream.listen((value) {
              if (value.isNotEmpty) {
                final data = String.fromCharCodes(value);
                _dataController.add(data);
              }
            });
          }
        }
      }
    }
  }

  Future<void> disconnect() async {
    await _scanSubscription?.cancel();
    await _notifySubscription?.cancel();
    await _connectionSubscription?.cancel();
    await _device?.disconnect();
    _device = null;
    _characteristic = null;
    _connectionStateController.add(BluetoothConnectionState.disconnected);
  }

  Future<void> sendThreshold(int threshold) async {
    if (_characteristic != null) {
      try {
        final msg = "THRESHOLD:$threshold";
        await _characteristic!.write(msg.codeUnits);
      } catch (e) {
        debugPrint("Error sending threshold: $e");
      }
    }
  }

  void dispose() {
    _scanSubscription?.cancel();
    _notifySubscription?.cancel();
    _connectionSubscription?.cancel();
    _dataController.close();
    _connectionStateController.close();
  }
}
