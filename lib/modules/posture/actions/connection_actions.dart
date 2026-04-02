import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:postura/shared/lib/permission_service.dart';
import 'package:postura/shared/components/ui/permission_dialog.dart';
import 'package:postura/shared/constants/strings/index.dart';

class ConnectionActions {
  final PermissionService _permissionService = PermissionService();

  Future<bool> ensurePermissions(BuildContext context) async {
    // Check if permissions are already granted
    bool granted = await _permissionService.checkBlePermissions();
    if (!context.mounted) return false;

    if (!granted) {
      final res = await showDialog<bool>(
        context: context,
        builder: (ctx) => PermissionDialog(
          icon: Icons.bluetooth_searching,
          title: HomeStrings.permissionRequired,
          message: HomeStrings.permissionDescription,
          buttonText: HomeStrings.grantPermission,
          onButtonPressed: () async {
            final isAlreadyDenied =
                await Permission.bluetoothScan.isPermanentlyDenied ||
                    await Permission.bluetoothConnect.isPermanentlyDenied ||
                    await Permission.location.isPermanentlyDenied;

            if (isAlreadyDenied) {
              await openAppSettings();
              if (ctx.mounted) Navigator.of(ctx).pop(false);
            } else {
              final result = await _permissionService.requestBlePermissions();
              if (ctx.mounted) Navigator.of(ctx).pop(result);
            }
          },
          onCancel: () => Navigator.of(ctx).pop(false),
        ),
      );

      if (res != true) return false;
      granted = res!;
    }

    if (granted) {
      // Check if Bluetooth is turned ON
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        if (!context.mounted) return false;

        final turnOn = await showDialog<bool>(
          context: context,
          builder: (ctx) => PermissionDialog(
            icon: Icons.bluetooth_disabled,
            title: "Bluetooth is Off",
            message: "Please turn on Bluetooth to connect with your device.",
            buttonText: "Turn On",
            onButtonPressed: () async {
              try {
                await FlutterBluePlus.turnOn();
              } catch (_) {}
              if (ctx.mounted) Navigator.of(ctx).pop(true);
            },
            onCancel: () => Navigator.of(ctx).pop(false),
          ),
        );
        return turnOn == true;
      }
    }

    return granted;
  }
}
