import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Frequently Asked Questions',
            [
              _buildFaqItem(
                'How do I manage library occupancy?',
                'You can view and manage library occupancy through the dashboard. The system automatically updates occupancy data in real-time.',
              ),
              _buildFaqItem(
                'What do the different seat statuses mean?',
                'Green indicates available seats, amber shows reserved seats, and red represents occupied seats.',
              ),
              _buildFaqItem(
                'How do notifications work?',
                'The system sends notifications when library occupancy exceeds your set threshold or when seats have been on hold for too long.',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Contact Support',
            [
              _buildContactCard(
                'Technical Support',
                'For technical issues and bug reports',
                Icons.computer,
                'support@library.com',
              ),
              _buildContactCard(
                'General Inquiries',
                'For general questions and feedback',
                Icons.help_outline,
                'info@library.com',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
      String title, String description, IconData icon, String email) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.email),
          onPressed: () {
            // TODO: Implement email functionality
          },
        ),
      ),
    );
  }
}
