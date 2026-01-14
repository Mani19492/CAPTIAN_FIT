# CaptainFit

CaptainFit is an interactive, animated offline-first mobile fitness & diet assistant built with Flutter.

## Features

- **AI-Powered Chat Assistant**: Chat with an intelligent assistant that understands your fitness needs
- **Food Logging**: Log what you eat through natural conversation
- **Workout Tracking**: Record your exercises with visual GIFs
- **Interactive Dashboard**: Beautiful animated UI with real-time stats
- **Local Storage**: All data stored securely on your device
- **Exercise GIFs**: Visual demonstrations for every workout

## Getting Started

1. Run `flutter pub get`
2. Run `flutter run`

## How to Use

### Chat Assistant
- Ask for food suggestions: "What should I eat for breakfast?"
- Log foods: "I ate a chicken salad"
- Get workout recommendations: "Suggest a leg workout"
- Log exercises: "I did 20 push-ups"

### Workout Tracker
- Browse suggested exercises with visual GIFs
- Track completed workouts
- View daily progress

### Profile
- See your fitness history
- Track your activity streak
- View food and workout history

## Tech Stack

- Flutter (Dart)
- SharedPreferences for local storage
- Material Design components
- Cupertino Icons

## Offline First

All data is stored locally on your device. No internet connection required!

## MVP Features Implemented

- Natural conversational logging (intent-based) with confirmation phrases ("I ate…", "I had…") and advice-only detection ("Can I eat…?").
- Local storage of meals, workouts and chat messages using SharedPreferences (lightweight MVP).
- Simple offline sync queue (stored locally) and connectivity-driven auto-sync scaffold (no remote writes unless Supabase configured).
- Authentication scaffolding and optional Supabase integration via environment variables (`SUPABASE_URL`, `SUPABASE_KEY`) using `flutter_dotenv`.
- Glassmorphism UI components (`lib/core/glass_card.dart`, `lib/core/glass_background.dart`) and dark theme (`lib/theme/futuristic_theme.dart`).
- Daily summary generator estimating calories from logs (`lib/services/summary_service.dart`).
- Basic mockups in `assets/mockups/` and unit/widget tests covering NLU, chat integration, and summaries.

### How to enable Supabase sync (optional)

1. Create a Supabase project and get `SUPABASE_URL` and `SUPABASE_KEY`.
2. Create a `.env` file at project root with:

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key
```

3. On app startup call:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:captain_fit/services/auth_service.dart';

Future<void> main() async {
  await dotenv.load();
  await AuthService.initSupabase();
  runApp(const MyApp());
}
```

Note: Currently sync logic simulates pushes; replace the TODOs in `lib/services/sync_service.dart` with your Supabase inserts when ready.

## Next recommended tasks

- Fully replace legacy SharedPreferences usage with the local DB (done for meals/workouts and migrated existing data).
- Implement exact remote sync logic (Supabase table schemas, conflict resolution, per-item ids) — full upsert/scaffold implemented in `lib/services/sync_service.dart`. For reliable behavior create unique `client_id` column and index on your Supabase `meals` and `workouts` tables. When `SUPABASE_URL`/`SUPABASE_KEY` are present the app will attempt upsert by `client_id` to avoid duplicates and handle offline-first writes safely.
- Add precise calorie lookup and parsing (serving Indian food items) with an extensible food database.
- Accessibility & animation profiling for 60–120Hz smoothness.
- CI: GitHub Actions workflow added (`.github/workflows/flutter-ci.yml`) to run analyzer and tests on PRs and pushes to `main`.
