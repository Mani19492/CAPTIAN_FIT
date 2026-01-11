import 'package:flutter/material.dart';
import '../core/glass_background.dart';
import '../core/glass_card.dart';
import '../storage/local_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int meals = 0;

  @override
  void initState() {
    super.initState();
    LocalStorage.getParsedMeals().then((m) {
      setState(() => meals = m.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'CaptainFit',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your fitness journey starts here',
                            style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ),
                    ),
                    GlassCard(
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Meals logged today', style: TextStyle(color: Color(0xFF9CA3AF))),
                            const SizedBox(height: 8),
                            Text('$meals', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Workouts this week', style: TextStyle(color: Color(0xFF9CA3AF))),
                            SizedBox(height: 8),
                            Text('3', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Feature cards carousel
                const Text('Features', style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 260,
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(Icons.restaurant_menu, color: Color(0xFF8B5CF6), size: 36),
                              SizedBox(height: 8),
                              Text('Meal Tracking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
                              SizedBox(height: 6),
                              Text('Log meals and track calories with ease.', style: TextStyle(color: Color(0xFF9CA3AF))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 260,
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(Icons.fitness_center, color: Color(0xFF8B5CF6), size: 36),
                              SizedBox(height: 8),
                              Text('Workouts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
                              SizedBox(height: 6),
                              Text('Discover guided workouts for all levels.', style: TextStyle(color: Color(0xFF9CA3AF))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 260,
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(Icons.chat_bubble_outline, color: Color(0xFF8B5CF6), size: 36),
                              SizedBox(height: 8),
                              Text('Community', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
                              SizedBox(height: 6),
                              Text('Join conversations, ask questions, and get support.', style: TextStyle(color: Color(0xFF9CA3AF))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // CTA
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: const Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
