import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:captain_fit/services/auth_service.dart';
import 'package:captain_fit/navigation/app_router.dart';
import 'package:captain_fit/theme/futuristic_theme.dart';
import 'package:captain_fit/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  // Load environment variables
  await dotenv.load();
  
  // Initialize Supabase if environment variables are present
  await AuthService.initSupabase();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CaptainFit',
      debugShowCheckedModeBanner: false,
      theme: FuturisticTheme.theme,
      home: const AppRouter(),
    );
  }
}