import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestBlePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<bool> checkBlePermissions() async {
    return await Permission.bluetoothScan.isGranted &&
           await Permission.bluetoothConnect.isGranted &&
           await Permission.location.isGranted;
  }
}
