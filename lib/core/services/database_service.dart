import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../../common/library.dart';
import '../../features/authentication/domain/user.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<List<Library>> getLibraries() async {
    try {
      final ref = _database.ref("libraries");
      final event = await ref.once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final data = snapshot.value;
        if (data is List) {
          return data
              .where((item) => item != null)
              .map((library) =>
                  Library.fromJson(Map<String, dynamic>.from(library)))
              .toList();
        } else if (data is Map) {
          return data.values
              .where((item) => item != null)
              .map((library) =>
                  Library.fromJson(Map<String, dynamic>.from(library)))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching libraries: $e');
      return [];
    }
  }

  Future<void> updateLibraryOccupancy(
      String libraryId, Map<String, dynamic> occupancyData) async {
    try {
      final ref = _database.ref("libraries/$libraryId/occupancy");
      await ref.update(occupancyData);
    } catch (e) {
      throw Exception('Failed to update library occupancy: $e');
    }
  }

  Future<void> updateUserManagedLibraries(
      String email, List<String> libraryIds) async {
    try {
      final userEmail = email.replaceAll('.', '_');
      final ref = _database.ref("users/$userEmail");
      await ref.update({'managed_libraries': libraryIds});
    } catch (e) {
      throw Exception('Failed to update managed libraries: $e');
    }
  }

  Future<User?> getUser(String email, String password) async {
    try {
      final userEmail = email.replaceAll('.', '_');
      final ref = _database.ref("users/$userEmail");
      final event = await ref.once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final userData = Map<String, dynamic>.from(snapshot.value as Map);
        if (userData['password'] == password) {
          return User.fromMap(userData);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<bool> createUser(User user) async {
    try {
      final userEmail = user.email.replaceAll('.', '_');
      final ref = _database.ref("users/$userEmail");
      await ref.set(user.toMap());
      return true;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}
