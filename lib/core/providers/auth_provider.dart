import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../../features/authentication/domain/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await DatabaseHelper.instance.getUser(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Starting registration for email: $email');
      final user = User(
        email: email,
        password: password,
        userType: 'user',
        lastLogin: DateTime.now(),
        managedLibraries: [],
      );

      final success = await DatabaseHelper.instance.createUser(user);
      debugPrint('Registration result: $success');

      if (success) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Registration error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    if (_currentUser == null) return {};
    return DatabaseHelper.instance.getUserDetails(_currentUser!.email);
  }

  Future<bool> updateManagedLibraries(
      String email, List<String> libraries) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await DatabaseHelper.instance
          .updateManagedLibraries(email, libraries);
      if (success && _currentUser?.email == email) {
        _currentUser = _currentUser?.copyWith(managedLibraries: libraries);
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('Error updating managed libraries: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }
}
