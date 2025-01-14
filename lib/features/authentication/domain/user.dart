class User {
  final String email;
  final String password;
  final String userType;
  final DateTime lastLogin;
  final List<String> managedLibraries;

  User({
    required this.email,
    required this.password,
    required this.userType,
    required this.lastLogin,
    required this.managedLibraries,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'user_type': userType,
      'last_login': lastLogin.millisecondsSinceEpoch,
      'managed_libraries': managedLibraries.join(','),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'],
      password: map['password'],
      userType: map['user_type'],
      lastLogin: DateTime.fromMillisecondsSinceEpoch(map['last_login']),
      managedLibraries: map['managed_libraries'].toString().split(',')
        ..removeWhere((e) => e.isEmpty),
    );
  }

  User copyWith({
    String? email,
    String? password,
    String? userType,
    DateTime? lastLogin,
    List<String>? managedLibraries,
  }) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      lastLogin: lastLogin ?? this.lastLogin,
      managedLibraries: managedLibraries ?? this.managedLibraries,
    );
  }
}
