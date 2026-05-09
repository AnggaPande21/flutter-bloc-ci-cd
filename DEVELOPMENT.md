# Development Guide

## Prerequisites

- Flutter SDK 3.24.0+
- Dart SDK 3.8.1+
- Android Studio or VS Code with Flutter plugin
- Android Emulator or physical device

## Setup Development Environment

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd bloccicd
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment (optional)**
   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

4. **Verify setup**
   ```bash
   flutter doctor
   flutter analyze
   flutter test
   ```

## Development Workflow

### Running the App

**Debug mode:**
```bash
flutter run
```

**Release mode:**
```bash
flutter run --release
```

**Specific device:**
```bash
flutter devices                    # List available devices
flutter run -d <device-id>         # Run on specific device
```

### Hot Reload

- Press `r` in terminal to hot reload
- Press `R` in terminal to hot restart
- Press `q` to quit

### Testing

**Run all tests:**
```bash
flutter test
```

**Run specific test file:**
```bash
flutter test test/presentation/bloc/post_bloc_test.dart
```

**Run with coverage:**
```bash
flutter test --coverage
```

**View coverage report (requires lcov):**
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

### Code Quality

**Static analysis:**
```bash
flutter analyze
```

**Format code:**
```bash
dart format lib test
```

**Fix formatting issues:**
```bash
dart format --fix lib test
```

### Building

**Android APK (debug):**
```bash
flutter build apk --debug
```

**Android APK (release):**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**Check build size:**
```bash
flutter build apk --analyze-size
```

## Project Structure

```
lib/
├── core/                          # Core utilities and shared code
│   ├── error/
│   │   ├── exceptions.dart        # Custom exception types
│   │   └── failures.dart          # Failure types for error handling
│   ├── network/
│   │   └── api_client.dart        # HTTP client wrapper
│   └── utils/
│       └── constants.dart         # App-wide constants
│
├── data/                          # Data layer (external data sources)
│   ├── datasources/
│   │   └── post_remote_data_source.dart  # API data source
│   ├── models/
│   │   └── post_model.dart        # Data transfer object
│   └── repositories/
│       └── post_repository_impl.dart     # Repository implementation
│
├── domain/                        # Domain layer (business logic)
│   ├── entities/
│   │   └── post.dart              # Business entity
│   ├── repositories/
│   │   └── post_repository.dart   # Repository contract
│   └── usecases/
│       ├── get_post_by_id.dart    # Single use case
│       └── get_posts.dart         # Use case for fetching posts
│
├── presentation/                  # Presentation layer (UI)
│   ├── bloc/
│   │   ├── post_bloc.dart         # BLoC logic
│   │   ├── post_event.dart        # BLoC events
│   │   └── post_state.dart        # BLoC states
│   ├── pages/
│   │   ├── post_detail_page.dart  # Detail screen
│   │   └── posts_list_page.dart   # List screen
│   └── widgets/                   # Reusable widgets
│       ├── empty_state.dart
│       ├── error_display.dart
│       ├── loading_indicator.dart
│       └── post_card.dart
│
├── injection_container.dart       # Dependency injection setup
└── main.dart                      # App entry point
```

## Clean Architecture Rules

1. **Dependency Rule**: Dependencies point inward
   - Presentation → Domain ← Data
   - Domain has NO dependencies on outer layers

2. **Layer Responsibilities**:
   - **Domain**: Business entities, repository contracts, use cases
   - **Data**: API calls, models, repository implementations
   - **Presentation**: UI, BLoC, widgets

3. **Error Handling**:
   - Data layer throws exceptions
   - Repository catches and converts to `Failure`
   - Domain returns `Either<Failure, T>`
   - Presentation handles failures in BLoC

## Adding New Features

### Example: Adding a "Comments" feature

1. **Domain Layer**:
   ```dart
   // lib/domain/entities/comment.dart
   // lib/domain/repositories/comment_repository.dart
   // lib/domain/usecases/get_comments.dart
   ```

2. **Data Layer**:
   ```dart
   // lib/data/models/comment_model.dart
   // lib/data/datasources/comment_remote_data_source.dart
   // lib/data/repositories/comment_repository_impl.dart
   ```

3. **Presentation Layer**:
   ```dart
   // lib/presentation/bloc/comment_bloc.dart
   // lib/presentation/pages/comments_page.dart
   // lib/presentation/widgets/comment_card.dart
   ```

4. **Register in DI**:
   ```dart
   // lib/injection_container.dart
   sl.registerLazySingleton<CommentRepository>(...);
   sl.registerLazySingleton(() => GetComments(sl()));
   sl.registerFactory(() => CommentBloc(...));
   ```

5. **Write Tests**:
   ```dart
   // test/domain/usecases/get_comments_test.dart
   // test/data/models/comment_model_test.dart
   // test/presentation/bloc/comment_bloc_test.dart
   ```

## Debugging Tips

### Enable verbose logging
```bash
flutter run -v
```

### Debug BLoC state changes
Add `Bloc.observer = SimpleBlocObserver();` in `main()`:
```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
```

### Inspect network calls
Use Flutter DevTools: `flutter run` then press `o` to open DevTools.

## Troubleshooting

### Tests failing
```bash
# Clear test cache
flutter test --clear-cache

# Run specific test with verbose output
flutter test --verbose test/presentation/bloc/post_bloc_test.dart
```

### Build issues
```bash
# Clean build cache
flutter clean

# Get dependencies again
flutter pub get

# Rebuild
flutter run
```

### Analyzer issues
```bash
# Run analysis
flutter analyze

# Fix formatting
dart format --fix lib test
```

## CI/CD

The project uses GitHub Actions for CI/CD. See `.github/workflows/ci-cd.yml`.

### Pipeline stages:
1. **Analyze**: Code formatting and static analysis
2. **Test**: Run all tests with coverage
3. **Build**: Create APK and App Bundle

### Triggering the pipeline:
- Push to `main` or `develop` branch
- Open pull request to `main` or `develop`

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

