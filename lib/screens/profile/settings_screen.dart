import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _darkMode = false; // Default value
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  final List<String> _languages = ['English', 'Spanish', 'French', 'Arabic'];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'AED'];

  @override
  void initState() {
    super.initState();
    // Load the saved theme preference if needed
    _loadThemePreference();
  }

  void _loadThemePreference() async {
    // Load the saved theme preference from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  void _saveThemePreference(bool isDarkMode) async {
    // Save the theme preference to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }

  Widget _buildSettingSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primaryGold,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryGold,
    );
  }

  Widget _buildDropdown<T>({
    required String title,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          DropdownButton<T>(
            value: value,
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            dropdownColor: AppTheme.darkBlack,
            style: const TextStyle(color: AppTheme.primaryGold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingSection('Notifications'),
            _buildSwitch(
              title: 'Push Notifications',
              subtitle: 'Receive push notifications for bookings and offers',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            _buildSwitch(
              title: 'Email Notifications',
              subtitle: 'Receive email updates about your bookings',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            _buildSettingSection('Appearance'),
            _buildSwitch(
              title: 'Dark Mode',
              subtitle: 'Toggle dark mode theme',
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                  _saveThemePreference(_darkMode);
                });
                // Update the app's theme
                if (_darkMode) {
                  // Apply dark theme
                  Theme.of(context).copyWith(
                    brightness: Brightness.dark,
                  );
                } else {
                  // Apply light theme
                  Theme.of(context).copyWith(
                    brightness: Brightness.light,
                  );
                }
              },
            ),
            _buildSettingSection('Regional'),
            _buildDropdown<String>(
              title: 'Language',
              value: _selectedLanguage,
              items: _languages,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  // TODO: Implement language switching
                }
              },
            ),
            _buildDropdown<String>(
              title: 'Currency',
              value: _selectedCurrency,
              items: _currencies,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                  // TODO: Implement currency switching
                }
              },
            ),
            _buildSettingSection('Privacy'),
            ListTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.primaryGold,
                size: 16,
              ),
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
            ListTile(
              title: const Text(
                'Terms of Service',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.primaryGold,
                size: 16,
              ),
              onTap: () {
                // TODO: Navigate to terms of service
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppTheme.softBlack,
                        title: const Text(
                          'Reset Settings',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'Are you sure you want to reset all settings to default?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _pushNotifications = true;
                                _emailNotifications = true;
                                _darkMode = false;
                                _selectedLanguage = 'English';
                                _selectedCurrency = 'USD';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Settings reset to default'),
                                  backgroundColor: AppTheme.darkBlack,
                                ),
                              );
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Reset All Settings'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
