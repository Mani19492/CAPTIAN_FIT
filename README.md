# CaptainFit

CaptainFit is an offline-first mobile fitness & diet assistant (Flutter).

## MVP Goals

- Log food in a chat-style UI
- Log workouts from a selection list
- Store all data locally (SharedPreferences)
- Minimal, premium dark glass UI

## Getting started

- flutter pub get
- flutter run -d <device>

## Project structure

- `lib/auth` — login screen
- `lib/navigation` — home shell (bottom navigation)
- `lib/chat` — chat UI for food logging
- `lib/workout` — workout logging UI
- `lib/storage` — local storage helpers

## Notes

This is an MVP focused on offline UX and local persistence. Cloud sync and calorie estimation are planned for post-MVP.
