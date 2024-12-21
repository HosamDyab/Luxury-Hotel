import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I make a reservation?',
      'answer':
          'You can make a reservation by selecting a room from our available listings and clicking the "Book Now" button. Follow the prompts to select your dates, number of guests, and complete the payment process.',
    },
    {
      'question': 'What is the check-in/check-out time?',
      'answer':
          'Check-in time is from 2:00 PM, and check-out time is until 12:00 PM (noon). Early check-in and late check-out may be available upon request, subject to availability.',
    },
    {
      'question': 'Is breakfast included in the room rate?',
      'answer':
          'Breakfast inclusion varies by room type and rate plan. Please check the room details during booking to see if breakfast is included in your rate.',
    },
    {
      'question': 'Do you offer airport transfers?',
      'answer':
          'Yes, we offer airport transfer services. Please contact our concierge desk at least 24 hours before your arrival to arrange transportation.',
    },
    {
      'question': 'What is your cancellation policy?',
      'answer':
          'Our standard cancellation policy allows free cancellation up to 24 hours before check-in. Cancellations made later may incur a charge equivalent to one night\'s stay.',
    },
    {
      'question': 'Is Wi-Fi available?',
      'answer':
          'Yes, complimentary high-speed Wi-Fi is available throughout the hotel for all guests.',
    },
  ];

  int? _expandedIndex;

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppTheme.softBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppTheme.primaryGold),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryGold),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.primaryGold,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFaqItem(Map<String, String> faq, int index) {
    final isExpanded = _expandedIndex == index;
    return Card(
      color: AppTheme.softBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppTheme.primaryGold),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            faq['question']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.remove : Icons.add,
            color: AppTheme.primaryGold,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedIndex = expanded ? index : null;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['answer']!,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              icon: Icons.chat,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Live chat feature coming soon'),
                    backgroundColor: AppTheme.darkBlack,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildContactOption(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '+201093601340',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling feature coming soon'),
                    backgroundColor: AppTheme.darkBlack,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildContactOption(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'support@luxuryhotel.com',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email feature coming soon'),
                    backgroundColor: AppTheme.darkBlack,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _faqs.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildFaqItem(_faqs[index], index),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Submit ticket feature coming soon'),
                      backgroundColor: AppTheme.darkBlack,
                    ),
                  );
                },
                icon: const Icon(Icons.support_agent),
                label: const Text('Submit Support Ticket'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
