import 'package:flutter/material.dart';
import 'package:captain_fit/services/auth_service.dart';
import 'package:captain_fit/services/sync_service.dart';
import 'package:captain_fit/core/glass_background.dart';
import 'package:captain_fit/core/glass_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _guestMode = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final g = await AuthService.isGuestMode();
    setState(() => _guestMode = g);
  }

  Future<void> _toggleGuest(bool v) async {
    await AuthService.setGuestMode(v);
    setState(() => _guestMode = v);
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    // navigate to login
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        title: const Text('Guest Mode', style: TextStyle(color: Colors.white)),
                        value: _guestMode,
                        onChanged: _toggleGuest,
                      ),
                      ListTile(
                        title: const Text('Sync with Supabase', style: TextStyle(color: Colors.white)),
                        subtitle: const Text('Enable cloud backup & cross-device sync', style: TextStyle(color: Colors.white70)),
                        trailing: IconButton(
                          icon: const Icon(Icons.sync, color: Colors.white),
                          onPressed: () async {
                            final ok = await SyncService.attemptSync();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(ok ? 'Sync completed' : 'Sync failed or no connection'),
                            ));
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Sign out', style: TextStyle(color: Colors.white)),
                        onTap: _signOut,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}