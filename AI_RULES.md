# AI Rules for CaptainFit

## Tech Stack

• **Flutter** - Cross-platform mobile development framework
• **Dart** - Primary programming language
• **SharedPreferences** - Local data storage solution
• **Material Design** - UI component library and design system
• **Cupertino Icons** - iOS-style icon library
• **Offline-first architecture** - All data stored locally without requiring internet connection

## Library Usage Rules

• **State Management**: Use Flutter's built-in state management (setState, InheritedWidget) for simple cases. For complex state, consider Provider or Riverpod if needed.

• **UI Components**: Prioritize Material Design widgets. Use Cupertino widgets only when iOS-specific appearance is required.

• **Local Storage**: Exclusively use SharedPreferences for all local data persistence. Do not add other storage solutions like SQLite unless absolutely necessary.

• **Networking**: Avoid adding HTTP clients (http, dio) as this is an offline-first app. All data should be stored locally.

• **External APIs**: Do not integrate with external APIs or services that require internet connectivity for core functionality.

• **UI Styling**: Use Flutter's built-in styling system. Avoid adding external styling packages.

• **Navigation**: Use Flutter's built-in Navigator and routing system.

• **Animations**: Use Flutter's animation framework. Avoid adding external animation libraries.

• **Images**: Only use local assets. Do not add image loading packages that require network requests.

• **Testing**: Use flutter_test for unit and widget testing.

## Core Principles

• Maintain offline functionality at all times
• Keep the app lightweight and fast
• Follow Material Design guidelines for Android and Cupertino guidelines for iOS
• Store all user data locally with SharedPreferences
• Prioritize user privacy by avoiding external data transmission