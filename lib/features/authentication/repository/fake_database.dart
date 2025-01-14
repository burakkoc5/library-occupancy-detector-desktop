import '../domain/user.dart';

class FakeDatabase {
  // Store users in memory
  static List<User> users = [
    User(
      email: 'test@test.com',
      password: 'password123',
      userType: 'user',
      lastLogin: DateTime.now(),
      managedLibraries: [],
    ),
    User(
      email: 'admin@admin.com',
      password: 'admin123',
      userType: 'administrator',
      lastLogin: DateTime.now(),
      managedLibraries: [],
    ),
    User(
      email: 'user@example.com',
      password: 'user123',
      userType: 'user',
      lastLogin: DateTime.now(),
      managedLibraries: [],
    ),
  ];

  // Add new user
  static void addUser(String email, String password) {
    if (users.any((user) => user.email == email)) {
      throw Exception('User already exists');
    }
    users.add(User(
      email: email,
      password: password,
      userType: 'user',
      lastLogin: DateTime.now(),
      managedLibraries: [],
    ));
  }

  // Validate user credentials
  static bool validateUser(String email, String password) {
    return users.any((user) =>
        user.email.toLowerCase() == email.toLowerCase() &&
        user.password == password);
  }

  // Get user by email
  static User? getUserByEmail(String email) {
    return users.firstWhere(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('User not found'),
    );
  }

  // Clear all users (useful for testing)
  static void clearUsers() {
    users = [];
  }

  // Reset to default users (useful for testing)
  static void resetToDefault() {
    users = [
      User(
        email: 'test@test.com',
        password: 'password123',
        userType: 'user',
        lastLogin: DateTime.now(),
        managedLibraries: [],
      ),
      User(
        email: 'admin@admin.com',
        password: 'admin123',
        userType: 'administrator',
        lastLogin: DateTime.now(),
        managedLibraries: [],
      ),
      User(
        email: 'user@example.com',
        password: 'user123',
        userType: 'user',
        lastLogin: DateTime.now(),
        managedLibraries: [],
      ),
    ];
  }
}
