import 'package:flutter/material.dart';
import '../dashboard/ai_dashboard_screen.dart';
import '../chat/ai_chat_screen.dart';
import '../workout/ai_workout_screen.dart';

class AIHomeShell extends StatefulWidget {
  const AIHomeShell({super.key});

  @override
  State<AIHomeShell> createState() => _AIHomeShellState();
}

class _AIHomeShellState extends State<AIHomeShell>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _navAnimController;

  final List<Widget> _screens = const [
    AIDashboardScreen(),
    AIChatScreen(),
    AIWorkoutScreen(),
  ];

  final List<NavigationItem> _navItems = [
    NavigationItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      color: Color(0xFF8B5CF6),
    ),
    NavigationItem(
      icon: Icons.chat_bubble_outline,
      label: 'AI Chat',
      color: Color(0xFF06B6D4),
    ),
    NavigationItem(
      icon: Icons.fitness_center,
      label: 'Workouts',
      color: Color(0xFF10B981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _navAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _navAnimController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    _navAnimController.forward(from: 0.0);
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          color: Colors.black.withOpacity(0.4),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            top: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = _currentIndex == index;
    final item = _navItems[index];

    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: ScaleTransition(
        scale: isActive
            ? Tween<double>(begin: 1, end: 1.1).animate(
                CurvedAnimation(parent: _navAnimController, curve: Curves.elasticOut),
              )
            : AlwaysStoppedAnimation<double>(1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? item.color.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Icon(
                  item.icon,
                  color: isActive ? item.color : Colors.white54,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? item.color : Colors.white54,
                ),
                child: Text(item.label),
              ),
              if (isActive)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}
