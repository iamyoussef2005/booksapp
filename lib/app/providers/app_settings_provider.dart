import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.notificationsEnabled = true,
    this.readingRemindersEnabled = true,
    this.downloadOnWifiOnly = true,
  });

  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool readingRemindersEnabled;
  final bool downloadOnWifiOnly;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? readingRemindersEnabled,
    bool? downloadOnWifiOnly,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      readingRemindersEnabled:
          readingRemindersEnabled ?? this.readingRemindersEnabled,
      downloadOnWifiOnly: downloadOnWifiOnly ?? this.downloadOnWifiOnly,
    );
  }
}

class AppSettingsNotifier extends AsyncNotifier<AppSettings> {
  static const _themeModeKey = 'theme_mode';
  static const _notificationsKey = 'notifications_enabled';
  static const _readingRemindersKey = 'reading_reminders_enabled';
  static const _wifiOnlyKey = 'download_on_wifi_only';

  @override
  Future<AppSettings> build() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final storedThemeMode = preferences.getString(_themeModeKey);

      return AppSettings(
        themeMode: _parseThemeMode(storedThemeMode),
        notificationsEnabled:
            preferences.getBool(_notificationsKey) ?? true,
        readingRemindersEnabled:
            preferences.getBool(_readingRemindersKey) ?? true,
        downloadOnWifiOnly: preferences.getBool(_wifiOnlyKey) ?? true,
      );
    } catch (_) {
      // Keep the account page usable even if preferences are unavailable,
      // for example after a hot reload that added a new plugin.
      return const AppSettings();
    }
  }

  Future<void> toggleThemeMode(bool isDarkMode) async {
    final current = state.valueOrNull ?? const AppSettings();
    final updated = current.copyWith(
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    final updated = current.copyWith(notificationsEnabled: enabled);
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> toggleReadingReminders(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    final updated = current.copyWith(readingRemindersEnabled: enabled);
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> toggleDownloadOnWifiOnly(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    final updated = current.copyWith(downloadOnWifiOnly: enabled);
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> _persist(AppSettings settings) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_themeModeKey, settings.themeMode.name);
      await preferences.setBool(
        _notificationsKey,
        settings.notificationsEnabled,
      );
      await preferences.setBool(
        _readingRemindersKey,
        settings.readingRemindersEnabled,
      );
      await preferences.setBool(
        _wifiOnlyKey,
        settings.downloadOnWifiOnly,
      );
    } catch (_) {
      // Swallow persistence failures so UI interactions remain safe.
    }
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }
}

final appSettingsProvider =
    AsyncNotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
