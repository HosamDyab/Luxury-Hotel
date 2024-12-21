import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFAQSection(),
          const SizedBox(height: 20),
          _buildContactSection(context),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Card(
      child: ExpansionTile(
        title: const Text('Frequently Asked Questions'),
        children: [
          _buildFAQItem(
            'How do I make a booking?',
            'You can make a booking by selecting a room from the home screen or search results, choosing your dates, and following the booking process.',
          ),
          _buildFAQItem(
            'What is the cancellation policy?',
            'Cancellations made 48 hours before check-in are fully refundable. Later cancellations may be subject to charges.',
          ),
          _buildFAQItem(
            'Is breakfast included?',
            'Breakfast inclusion varies by room type and package selected. Please check the room details for specific information.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(answer),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              Icons.phone,
              'Phone',
              '+201093601340',
              () {},
            ),
            _buildContactItem(
              Icons.email,
              'Email',
              'hosam1dyab2@gmail.com',
              () {},
            ),
            _buildContactItem(
              Icons.chat,
              'Live Chat',
              'Start a conversation',
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
