import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'account_settings_page.dart';
import 'managed_libraries_page.dart';
import 'access_logs_page.dart';
import 'help_support_page.dart';
import 'user_management_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
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
            final managedLibraries = userDetails['managed_libraries']
                    ?.toString()
                    .split(',')
                    .where((e) => e.isNotEmpty)
                    .toList() ??
                [];
            final isAdmin = userDetails['user_type'] == 'administrator';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person,
                                  size: 50, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              authProvider.currentUser?.email ??
                                  'Library Manager',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              userDetails['user_type']
                                      ?.toString()
                                      .toUpperCase() ??
                                  'USER',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          if (isAdmin)
                            _buildProfileTile(
                              'User Management',
                              'Manage users and their libraries',
                              Icons.people,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UserManagementPage(),
                                  ),
                                );
                              },
                            ),
                          if (isAdmin) const Divider(height: 1),
                          _buildProfileTile(
                            'Account Settings',
                            'Update your account information',
                            Icons.manage_accounts,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AccountSettingsPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _buildProfileTile(
                            'Managed Libraries',
                            '${managedLibraries.length} libraries assigned',
                            Icons.library_books,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ManagedLibrariesPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _buildProfileTile(
                            'Access Logs',
                            'View your recent activities',
                            Icons.history,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccessLogsPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _buildProfileTile(
                            'Help & Support',
                            'Get help with the system',
                            Icons.help_outline,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpSupportPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          _buildProfileTile(
                            'Sign Out',
                            'Log out of your account',
                            Icons.logout,
                            () {
                              context.read<AuthProvider>().signOut();
                            },
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quick Stats',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildQuickStat(
                              'Last Login',
                              DateFormat('MMM d, y HH:mm').format(lastLogin),
                              Icons.access_time,
                            ),
                            const SizedBox(height: 12),
                            _buildQuickStat(
                              'Managed Libraries',
                              '${managedLibraries.length} Libraries',
                              Icons.library_books,
                            ),
                            const SizedBox(height: 12),
                            _buildQuickStat(
                              'Role',
                              userDetails['user_type']
                                      ?.toString()
                                      .toUpperCase() ??
                                  'USER',
                              Icons.admin_panel_settings,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
