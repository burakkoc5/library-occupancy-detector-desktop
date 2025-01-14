import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../features/authentication/domain/user.dart';
import '../../core/database/database_helper.dart';
import 'library_assignment_page.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: FutureBuilder<List<User>>(
        future: DatabaseHelper.instance.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final currentUser = context.read<AuthProvider>().currentUser;

              // Don't show the current admin user in the list
              if (currentUser?.email == user.email) {
                return const SizedBox.shrink();
              }

              return Card(
                child: ListTile(
                  title: Text(user.email),
                  subtitle: Text('User Type: ${user.userType}'),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LibraryAssignmentPage(
                            targetUser: user,
                          ),
                        ),
                      );
                    },
                    child: const Text('Assign Libraries'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
