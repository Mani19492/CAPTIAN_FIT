import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_screen.dart';
import 'navigation/home_shell.dart';
import 'core/app_colors.dart';

void main() {
  runApp(const CaptainFitApp());
}

class CaptainFitApp extends StatelessWidget {
  const CaptainFitApp({super.key});

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
      ),
      home: FutureBuilder<bool>(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data! ? const HomeShell() : LoginScreen();
        },
      ),
    );
  }
}
