import '../../features/authentication/domain/user.dart';
import '../services/database_service.dart';

class AuthRepository {
  final DatabaseService _db = DatabaseService();

  Future<User> login(String email, String password) async {
    try {
      final user = await _db.getUser(email, password);
      if (user != null) {
        return user;
      }
      throw Exception('Invalid credentials');
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<User> register(String email, String password) async {
    try {
      final user = User(
        email: email,
        password: password,
        userType: 'user',
        lastLogin: DateTime.now(),
        managedLibraries: [],
      );

      final success = await _db.createUser(user);
      if (success) {
        return user;
      }
      throw Exception('Failed to create user');
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> updateManagedLibraries(
      String email, List<String> libraryIds) async {
    try {
      await _db.updateUserManagedLibraries(email, libraryIds);
    } catch (e) {
      throw Exception('Failed to update managed libraries: ${e.toString()}');
    }
  }
}
