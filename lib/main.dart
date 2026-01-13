import 'package:flutter/material.dart';
import 'package:captain_fit/navigation/app_router.dart';
import 'package:captain_fit/theme/futuristic_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaptainFit',
      theme: FuturisticTheme.darkTheme,
      home: const AppRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}