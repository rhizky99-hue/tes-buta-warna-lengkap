import 'package:flutter/material.dart';
import '../../data/local_storage_service.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  static Future<void> loadTheme() async {
    final mode = await LocalStorageService().getThemeMode();
    if (mode == 'light') {
      themeMode.value = ThemeMode.light;
    } else if (mode == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
  }

  static Future<void> setTheme(String mode) async {
    if (mode == 'light') {
      themeMode.value = ThemeMode.light;
    } else if (mode == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
    await LocalStorageService().setThemeMode(mode);
  }
}
