import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  static const _key = 'theme_mode'; // values: system|light|dark

  final mode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key) ?? 'system';
      final m = _fromString(saved);
      mode.value = m;
      // apply immediately
      Get.changeThemeMode(m);
    } catch (_) {
      // ignore
    }
  }

  Future<void> setMode(ThemeMode newMode) async {
    mode.value = newMode;
    Get.changeThemeMode(newMode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, _toString(newMode));
    } catch (_) {
      // ignore
    }
  }

  String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _fromString(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
