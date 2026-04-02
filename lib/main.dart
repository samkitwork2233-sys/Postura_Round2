import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:postura/shared/constants/theme.dart';
import 'package:postura/app/router/app_router.dart';
import 'package:postura/modules/storage/services/history_service.dart';
import 'package:postura/modules/storage/services/settings_service.dart';
import 'package:postura/modules/storage/core/settings_provider.dart';
import 'package:postura/modules/storage/core/history_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Storage Initialization
  await Hive.initFlutter();
  final historyService = HistoryService();
  await historyService.init();

  final prefs = await SharedPreferences.getInstance();
  final settingsService = SettingsService(prefs);

  runApp(
    ProviderScope(
      overrides: [
        historyServiceProvider.overrideWithValue(historyService),
        settingsServiceProvider.overrideWithValue(settingsService),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Postura',
        debugShowCheckedModeBanner: false,
        themeMode: settings.themeMode,
        theme: AppTheme.lightSafe(),
        darkTheme: AppTheme.darkSafe(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
