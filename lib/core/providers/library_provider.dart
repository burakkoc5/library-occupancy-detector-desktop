import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/library.dart';
import '../services/database_service.dart';
import 'settings_provider.dart';
import 'auth_provider.dart';

class LibraryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  Timer? _refreshTimer;
  final Map<String, DateTime> _holdStartTimes = {};
  List<Library> _libraries = [];
  Library? _selectedLibrary;
  bool _isLoading = false;
  AuthProvider? _authProvider;
  SettingsProvider? _settingsProvider;

  List<Library> get libraries => _libraries;
  Library? get selectedLibrary => _selectedLibrary;
  bool get isLoading => _isLoading;

  void initialize(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _startRefreshTimer();
    fetchLibraries();
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    if (_settingsProvider == null) return;

    _refreshTimer = Timer.periodic(
      Duration(seconds: _settingsProvider!.refreshFrequency),
      (_) => fetchLibraries(),
    );
  }

  void updateRefreshTimer() {
    _startRefreshTimer();
  }

  List<Library> filterLibrariesForUser(List<Library> allLibraries) {
    final currentUser = _authProvider?.currentUser;

    if (currentUser == null) return [];
    if (currentUser.userType == 'administrator') return allLibraries;

    return allLibraries
        .where((lib) => currentUser.managedLibraries.contains(lib.id))
        .toList();
  }

  Future<void> fetchLibraries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newLibraries = await _databaseService.getLibraries();

      // Filter libraries based on user type
      _libraries = filterLibrariesForUser(newLibraries);

      // Check occupancy rates and send notifications
      if (_settingsProvider != null) {
        for (final library in _libraries) {
          final occupancyRate =
              (library.occupiedChairs / library.totalChairs * 100).round();
          if (occupancyRate >= _settingsProvider!.occupancyThreshold) {
            _settingsProvider!
                .showOccupancyNotification(library.name, occupancyRate);
          }

          // Check hold times
          for (final seat in library.seats) {
            if (seat.status == 'hold') {
              final holdStart = _holdStartTimes[seat.id] ?? DateTime.now();
              if (!_holdStartTimes.containsKey(seat.id)) {
                _holdStartTimes[seat.id] = holdStart;
              }

              final holdDuration =
                  DateTime.now().difference(holdStart).inMinutes;
              if (holdDuration >= _settingsProvider!.holdTimeThreshold) {
                _settingsProvider!
                    .showHoldTimeNotification(library.name, seat.id);
                // Reset the hold time after notification
                _holdStartTimes.remove(seat.id);
              }
            } else {
              // Remove hold time if seat is no longer on hold
              _holdStartTimes.remove(seat.id);
            }
          }
        }
      }

      // Update selected library
      if (_libraries.isEmpty) {
        _selectedLibrary = null;
      } else if (_selectedLibrary != null) {
        final existingLibrary =
            _libraries.where((lib) => lib.id == _selectedLibrary!.id).toList();
        _selectedLibrary = existingLibrary.isNotEmpty
            ? existingLibrary.first
            : _libraries.first;
      } else {
        _selectedLibrary = _libraries.first;
      }
    } catch (e) {
      debugPrint('Error fetching libraries: $e');
      _libraries = [];
      _selectedLibrary = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectLibrary(Library library) {
    _selectedLibrary = library;
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
