import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSettingsItem(context, Icons.edit, 'Edit Calorie Goal', () {
          // TODO: Navigate to Edit Profile/Goal screen
          print('Navigate to Edit Calorie Goal');
        }),
        const Divider(),
        _buildSettingsItem(context, Icons.feedback, 'Give Feedback', () {
          // TODO: Navigate to Feedback screen/form
          print('Navigate to Give Feedback');
        }),
      ],
    );
  }

  // Helper for individual setting item
  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
