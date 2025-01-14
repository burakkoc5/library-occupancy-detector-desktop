import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: const [
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.amber),
                  title: Text('High Occupancy Alert'),
                  subtitle: Text('Library A has reached 85% occupancy'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.red),
                  title: Text('Hold Time Alert'),
                  subtitle: Text(
                      'Seat A1 in Library B has been on hold for over 30 minutes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
