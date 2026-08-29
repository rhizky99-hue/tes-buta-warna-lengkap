import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/test_result.dart';

class LocalStorageService {
  static const String _keyHistory = 'tes_buta_warna_history';
  static const String _keyThemeMode = 'app_theme_mode'; // 'system', 'light', 'dark'
  static const String _keySoundEnabled = 'app_sound_enabled';
  static const String _keyHapticEnabled = 'app_haptic_enabled';
  static const String _keyTimerDuration = 'app_timer_duration'; // in seconds (0 = disabled, 3, 5, 10)

  // Singleton instance
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  Future<bool> saveTestResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(_keyHistory) ?? [];
    
    // Convert new result to json string
    final jsonStr = jsonEncode(result.toJson());
    list.insert(0, jsonStr); // Newest first

    // Limit history to 50 items to keep storage neat
    if (list.length > 50) {
      list = list.sublist(0, 50);
    }

    return await prefs.setStringList(_keyHistory, list);
  }

  Future<List<TestResult>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyHistory) ?? [];
    
    List<TestResult> results = [];
    for (var item in list) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        results.add(TestResult.fromJson(map));
      } catch (e) {
        // Skip corrupted entry
      }
    }
    return results;
  }

  Future<bool> deleteTestResult(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyHistory) ?? [];
    
    final updated = list.where((item) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        return map['id'] != id;
      } catch (_) {
        return false;
      }
    }).toList();

    return await prefs.setStringList(_keyHistory, updated);
  }

  Future<bool> clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_keyHistory);
  }

  // Preferences
  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode);
  }

  Future<bool> getSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySoundEnabled, enabled);
  }

  Future<bool> getHapticEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHapticEnabled) ?? true;
  }

  Future<void> setHapticEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHapticEnabled, enabled);
  }

  Future<int> getTimerDuration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTimerDuration) ?? 0; // 0 = no limit
  }

  Future<void> setTimerDuration(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTimerDuration, seconds);
  }
}
