import 'package:flutter/material.dart';
import 'package:captain_fit/services/summary_service.dart';
import 'package:captain_fit/core/glass_background.dart';
import 'package:captain_fit/core/glass_card.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  DailySummary? _summary;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await SummaryService.dailySummary(DateTime.now());
    setState(() {
      _summary = s;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text('Today\'s Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 12),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(child: Text('Meals logged', style: TextStyle(color: Color(0xFF9CA3AF)))),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 600),
                                  child: Text('${_summary?.mealsLogged ?? 0}', key: ValueKey(_summary?.mealsLogged ?? 0), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Expanded(child: Text('Workouts', style: TextStyle(color: Color(0xFF9CA3AF)))),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 600),
                                  child: Text('${_summary?.workoutsLogged ?? 0}', key: ValueKey(_summary?.workoutsLogged ?? 0), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Expanded(child: Text('Calories in', style: TextStyle(color: Color(0xFF9CA3AF)))),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 600),
                                  child: Text('${_summary?.caloriesIn ?? 0} kcal', key: ValueKey(_summary?.caloriesIn ?? 0), style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(child: Text('Calories out', style: TextStyle(color: Color(0xFF9CA3AF)))),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 600),
                                  child: Text('${_summary?.caloriesOut ?? 0} kcal', key: ValueKey(_summary?.caloriesOut ?? 0), style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Expanded(child: Text('Status', style: TextStyle(color: Color(0xFF9CA3AF)))),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 600),
                                  child: Row(
                                    key: ValueKey(_summary?.status ?? ''),
                                    children: [
                                      Icon(_summary?.status == 'Fat loss supported' ? Icons.check_circle : Icons.warning, color: _summary?.status == 'Fat loss supported' ? const Color(0xFF10B981) : const Color(0xFFFFB800)),
                                      const SizedBox(width: 6),
                                      Text(_summary?.status ?? '', style: const TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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