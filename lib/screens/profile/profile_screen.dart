import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:luxury_hotel/global/global_var.dart';
import 'package:luxury_hotel/screens/booking/booking_history_screen.dart';
import 'package:luxury_hotel/screens/profile/edit_profile_screen.dart';
import 'package:luxury_hotel/screens/profile/about_screen.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppTheme.softBlack,
                    title: const Text('Logout', style: TextStyle(color: Colors.white)),
                    content: const Text(
                      'Are you sure you want to logout?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Clear user data
                          final userProvider = Provider.of<UserProvider>(
                            context,
                            listen: false,
                          );
                          userProvider.clearUser();
                          
                          // Reset global variables
                          GlobalVar.name = '';
                          GlobalVar.email = '';
                          
                          // Navigate to login screen
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryGold,
              child: Icon(
                Icons.person,
                size: 50,
                color: AppTheme.darkBlack,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              GlobalVar.name,
              style: Theme.of(context).textTheme.displayMedium,
            ),
             Text(
              GlobalVar.email,
              style: const TextStyle(color: AppTheme.primaryGold),
            ),
            const SizedBox(height: 32),
            _buildProfileSection(
              title: 'Edit Profile',
              icon: Icons.notifications,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfileScreen()));
              },),
            _buildProfileSection(
              title: 'My Bookings',
              icon: Icons.book_online,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                   builder: (context) => const BookingHistoryScreen(),
                ));
              },
            ),
            _buildProfileSection(
              title: 'Payment Methods',
              icon: Icons.payment,
              onTap: () {
                Navigator.pushNamed(context, '/payment-methods');
              },
            ),
            _buildProfileSection(
              title: 'Notifications',
              icon: Icons.notifications,
              onTap: () {
                // TODO: Navigate to notifications
              },
            ),
            _buildProfileSection(
              title: 'Settings',
              icon: Icons.settings,
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            _buildProfileSection(
              title: 'Help & Support',
              icon: Icons.help,
              onTap: () {
                Navigator.pushNamed(context, '/help-support');
              },
            ),
            _buildProfileSection(
              title: 'About Us',
              icon: Icons.info,
              onTap: () {
                _navigateToAbout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutScreen()),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppTheme.softBlack,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppTheme.primaryGold),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryGold),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppTheme.primaryGold),
        onTap: onTap,
      ),
    );
  }
}
