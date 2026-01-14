import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _ProfileSection(),
            const _PreferencesSection(),
            const _NotificationsSection(),
            const _DataSection(),
            const _AboutSection(),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text('John Doe'),
            subtitle: const Text('john.doe@example.com'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Edit profile
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Fitness Goals'),
            subtitle: const Text('Lose weight, build muscle'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Set goals
            },
          ),
        ],
      ),
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            subtitle: Text('Dark mode'),
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            value: true,
            onChanged: (value) {
              // Toggle notifications
            },
          ),
          const Divider(),
          SwitchListTile(
            secondary: const Icon(Icons.animation),
            title: const Text('Animations'),
            value: true,
            onChanged: (value) {
              // Toggle animations
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ListTile(
            title: Text('Notifications'),
            subtitle: Text('Manage notification preferences'),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Workout Reminders'),
            value: true,
            onChanged: (value) {
              // Toggle workout reminders
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Meal Reminders'),
            value: true,
            onChanged: (value) {
              // Toggle meal reminders
            },
          ),
        ],
      ),
    );
  }
}

class _DataSection extends StatelessWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ListTile(
            title: Text('Data Management'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup Data'),
            onTap: () {
              // Backup data
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Data'),
            onTap: () {
              // Restore data
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Clear Data'),
            onTap: () {
              // Clear data
            },
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const ListTile(
            title: Text('About'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            onTap: () {
              // Show terms
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Show privacy policy
            },
          ),
        ],
      ),
    );
  }
}