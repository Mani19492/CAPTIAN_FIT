import 'package:flutter/material.dart';
import '../core/glass_background.dart';
import '../core/glass_card.dart';
import '../storage/local_storage.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int meals = 0;

  @override
  void initState() {
    super.initState();
    LocalStorage.getMeals().then((m) {
      setState(() => meals = m.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('CaptainFit', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 20),
                GlassCard(
                  child: Text('Meals logged today: $meals'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
