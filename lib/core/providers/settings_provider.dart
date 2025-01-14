import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../database/database_helper.dart';

class SettingsProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool _notificationsEnabled = true;
  int _occupancyThreshold = 80;
  int _refreshFrequency = 5;
  int _holdTimeThreshold = 30;

  bool get notificationsEnabled => _notificationsEnabled;
  int get occupancyThreshold => _occupancyThreshold;
  int get refreshFrequency => _refreshFrequency;
  int get holdTimeThreshold => _holdTimeThreshold;

  SettingsProvider() {
    _initSettings();
  }

  Future<void> _initSettings() async {
    if (_isInitialized) return;

    // Initialize notifications
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettingsMacOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await _notifications.initialize(initializationSettings);

    // Load settings from database
    final settings = await _db.getSettings();
    _notificationsEnabled = settings['notification_enabled'] == 1;
    _occupancyThreshold = settings['occupancy_threshold'];
    _refreshFrequency = settings['refresh_frequency'];
    _holdTimeThreshold = settings['hold_time_threshold'];
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _db.updateSettings({
      'notification_enabled': enabled ? 1 : 0,
    });
    notifyListeners();
  }

  Future<void> setOccupancyThreshold(int threshold) async {
    _occupancyThreshold = threshold;
    await _db.updateSettings({
      'occupancy_threshold': threshold,
    });
    notifyListeners();
  }

  Future<void> setRefreshFrequency(int frequency) async {
    _refreshFrequency = frequency;
    await _db.updateSettings({
      'refresh_frequency': frequency,
    });
    notifyListeners();
  }

  Future<void> setHoldTimeThreshold(int minutes) async {
    _holdTimeThreshold = minutes;
    await _db.updateSettings({
      'hold_time_threshold': minutes,
    });
    notifyListeners();
  }

  Future<void> showOccupancyNotification(
      String libraryName, int occupancyRate) async {
    if (!_notificationsEnabled || occupancyRate < _occupancyThreshold) return;

    await _notifications.show(
      0,
      'High Occupancy Alert',
      '$libraryName has reached $occupancyRate% occupancy',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'occupancy_alerts',
          'Occupancy Alerts',
          channelDescription: 'Alerts for high library occupancy',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showHoldTimeNotification(
      String libraryName, String seatId) async {
    if (!_notificationsEnabled) return;

    await _notifications.show(
      1,
      'Hold Time Alert',
      'Seat $seatId in $libraryName has been on hold for over $_holdTimeThreshold minutes',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hold_time_alerts',
          'Hold Time Alerts',
          channelDescription: 'Alerts for exceeded hold times',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
