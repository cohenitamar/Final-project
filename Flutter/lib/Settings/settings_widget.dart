import 'package:IOFit/Login/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure you have provider package
import 'ChangePasswordPage.dart';
import 'settings_provider.dart'; // Import your new provider

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF062029);
    final Color orangeColor = const Color(0xFFEA6D13);

    final TextStyle titleStyle = TextStyle(
      fontFamily: 'Readex Pro',
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    );

    final TextStyle optionStyle = TextStyle(
      fontFamily: 'Readex Pro',
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );

    // Access your provider
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const SizedBox(width: 8.0),
            Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 24.0,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            // Account Section
            buildSectionTitle('Account', titleStyle),
            buildSettingsOption(
              title: 'Change Password',
              icon: Icons.lock,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ),
                ).then((result) {
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result),
                        backgroundColor:
                        result == "Password updated successfully"
                            ? Colors.green
                            : Colors.grey,
                      ),
                    );
                  }
                });
              },
              textStyle: optionStyle,
            ),
            const Divider(color: Colors.grey),

            // Preferences Section
            buildSectionTitle('Preferences', titleStyle),
            buildSwitchOption(
              title: 'Reminder Notifications',
              icon: Icons.notifications,
              value: settingsProvider.reminderNotifications,
              onChanged: (value) {
                settingsProvider.setReminderNotifications(value,context);
              },
              activeColor: orangeColor,
              textStyle: optionStyle,
            ),
            const Divider(color: Colors.grey),

            // Logout
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              title: Text(
                'Logout',
                style: optionStyle.copyWith(color: Colors.redAccent),
              ),
              onTap: () async {
                await settingsProvider.signOut(context);
                // After sign-out completes, navigate to the Login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWidget()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build section titles
  Widget buildSectionTitle(String title, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
      child: Text(
        title,
        style: style,
      ),
    );
  }

  // Helper method to build settings options (without a switch)
  Widget buildSettingsOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required TextStyle textStyle,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: textStyle,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16.0,
      ),
      onTap: onTap,
    );
  }

  // Helper method to build switch options
  Widget buildSwitchOption({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color activeColor,
    required TextStyle textStyle,
  }) {
    return SwitchListTile(
      secondary: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: textStyle,
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFE3E3E4),
      activeTrackColor: activeColor,
    );
  }
}
