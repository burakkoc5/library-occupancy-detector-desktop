import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/auth_provider.dart';

class AccessLogsPage extends StatelessWidget {
  const AccessLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Logs'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.currentUser == null) {
            return const Center(child: Text('Please log in'));
          }

          return FutureBuilder<Map<String, dynamic>>(
            future: authProvider.getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final userDetails = snapshot.data ?? {};
              final lastLogin = DateTime.fromMillisecondsSinceEpoch(
                  userDetails['last_login'] ??
                      DateTime.now().millisecondsSinceEpoch);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildLogCard(
                    'Last Login',
                    DateFormat('MMM d, y HH:mm').format(lastLogin),
                    Icons.login,
                  ),
                  const SizedBox(height: 16),
                  _buildLogCard(
                    'Account Created',
                    'Account creation date not available',
                    Icons.person_add,
                  ),
                  const SizedBox(height: 16),
                  _buildLogCard(
                    'Last Password Change',
                    'Password change history not available',
                    Icons.lock_clock,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLogCard(String title, String timestamp, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(timestamp),
      ),
    );
  }
}
