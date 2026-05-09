# BlocCI/CD - Flutter Clean Architecture Demo

![CI/CD](https://github.com/AnggaPande21/flutter-bloc-ci-cd/workflows/Flutter%20CI%2FCD/badge.svg)
[![GitHub](https://img.shields.io/badge/GitHub-flutter--bloc--ci--cd-blue?logo=github)](https://github.com/AnggaPande21/flutter-bloc-ci-cd)

A production-ready Flutter application demonstrating **Clean Architecture**, **BLoC state management**, and **CI/CD** best practices.

## 🚀 Features

- ✅ **Clean Architecture** (Data, Domain, Presentation layers)
- ✅ **BLoC State Management** with flutter_bloc
- ✅ **Dependency Injection** using GetIt
- ✅ **REST API Integration** (JSONPlaceholder)
- ✅ **Comprehensive Testing** (Unit, Widget, BLoC tests)
- ✅ **CI/CD Pipeline** with GitHub Actions
- ✅ **Reusable Widgets** (PostCard, LoadingIndicator, ErrorDisplay, EmptyState)
- ✅ **Error Handling** with Either monad (dartz)
- ✅ **Pull-to-Refresh** functionality

## 📱 Screenshots

The app fetches and displays posts from the JSONPlaceholder API with a clean, modern UI.

## 🏗️ Architecture

### Clean Architecture Layers

```
lib/
├── core/                   # Core utilities
│   ├── error/             # Failures and exceptions
│   ├── network/           # API client
│   └── utils/             # Constants
├── data/                  # Data layer
│   ├── datasources/       # Remote data sources
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository contracts
│   └── usecases/          # Business logic
├── presentation/          # Presentation layer
│   ├── bloc/              # BLoC (State management)
│   ├── pages/             # UI screens
│   └── widgets/           # Reusable widgets
└── injection_container.dart # Dependency injection setup
```

### Data Flow

```
UI → BLoC → UseCase → Repository → DataSource → API
                ↓
           Either<Failure, Data>
                ↓
            State Update
                ↓
           UI Rebuild
```

## 🛠️ Tech Stack

- **Flutter SDK**: 3.24.0+
- **Dart SDK**: ^3.8.1
- **State Management**: flutter_bloc ^8.1.3
- **DI**: get_it ^7.6.4
- **Networking**: http ^1.1.0
- **Functional Programming**: dartz ^0.10.1
- **Testing**: bloc_test ^9.1.5, mocktail ^1.0.1

## 🚦 Getting Started

### Prerequisites

- Flutter SDK (3.24.0 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/bloccicd.git
cd bloccicd
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

Run specific test file:
```bash
flutter test test/presentation/bloc/post_bloc_test.dart
```

## 🔍 Code Quality

Run static analysis:
```bash
flutter analyze
```

Format code:
```bash
dart format lib test
```

## 🏗️ Build

Build release APK:
```bash
flutter build apk --release
```

Build App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

## 🔄 CI/CD Pipeline

This project uses **GitHub Actions** for continuous integration and deployment.

### Pipeline Jobs

1. **Analyze**: Code formatting and static analysis
2. **Test**: Run all tests with coverage
3. **Build Android**: Build release APK
4. **Build App Bundle**: Build AAB (main branch only)

### Triggers

- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`

### Artifacts

Build artifacts (APK, AAB) are uploaded and available for download from GitHub Actions.

## 📦 Dependencies

### Main Dependencies
- `flutter_bloc`: BLoC state management
- `equatable`: Value equality for entities and states
- `get_it`: Dependency injection
- `http`: HTTP client for API calls
- `dartz`: Functional programming (Either monad)

### Dev Dependencies
- `flutter_test`: Testing framework
- `bloc_test`: BLoC testing utilities
- `mocktail`: Mocking library
- `flutter_lints`: Linting rules

## 🎯 Project Structure

### Key Files

- `lib/main.dart`: App entry point with DI initialization
- `lib/injection_container.dart`: Dependency injection setup
- `lib/core/network/api_client.dart`: HTTP client wrapper
- `lib/presentation/bloc/post_bloc.dart`: BLoC for post management
- `.github/workflows/ci-cd.yml`: CI/CD pipeline configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 API Reference

This app uses the [JSONPlaceholder](https://jsonplaceholder.typicode.com/) API:
- Base URL: `https://jsonplaceholder.typicode.com`
- Endpoint: `/posts`
- Response: List of posts with id, userId, title, body

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

Built with ❤️ using Flutter and Clean Architecture principles.

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [JSONPlaceholder API](https://jsonplaceholder.typicode.com/)

