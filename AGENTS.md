app# AGENTS.md

## Project Snapshot
- Flutter app using **Clean Architecture** with BLoC state management
- Structure: `data/` (models, datasources, repository impl), `domain/` (entities, usecases, repository contracts), `presentation/` (BLoC, pages, widgets)
- External API: **JSONPlaceholder** posts endpoint (`https://jsonplaceholder.typicode.com/posts`)
- Dependency injection via **GetIt** (`lib/injection_container.dart`)
- CI/CD: GitHub Actions workflow (`.github/workflows/ci-cd.yml`)

## Architecture and Data Flow

### Clean Architecture Layers
**Domain Layer** (`lib/domain/`):
- `entities/post.dart`: Core business entity (id, userId, title, body)
- `repositories/post_repository.dart`: Repository contract (returns `Either<Failure, T>`)
- `usecases/get_posts.dart`, `get_post_by_id.dart`: Single-responsibility use cases

**Data Layer** (`lib/data/`):
- `models/post_model.dart`: Extends domain entity, adds JSON serialization
- `datasources/post_remote_data_source.dart`: API calls via `ApiClient`
- `repositories/post_repository_impl.dart`: Implements domain contract, converts exceptions to `Failure`

**Presentation Layer** (`lib/presentation/`):
- `bloc/post_bloc.dart`: BLoC managing `PostState` (Initial/Loading/Loaded/Error)
- `pages/posts_list_page.dart`: Main screen with pull-to-refresh
- `pages/post_detail_page.dart`: Detail screen for single post
- `widgets/`: Reusable components (`PostCard`, `LoadingIndicator`, `ErrorDisplay`, `EmptyState`)

### State Management Flow
1. UI dispatches `LoadPostsEvent` → `PostBloc`
2. BLoC calls `GetPosts` use case → `PostRepository`
3. Repository fetches from `PostRemoteDataSource` → `ApiClient`
4. Response flows back as `Either<Failure, List<Post>>`
5. BLoC emits new state → UI rebuilds via `BlocBuilder`

### Dependency Injection
- All dependencies registered in `lib/injection_container.dart`
- GetIt service locator pattern: `sl<PostBloc>()` provides instances
- Layers are decoupled: Presentation → Domain ← Data

## Critical Dev Workflows

### Setup and Run
```bash
flutter pub get                    # Install dependencies
flutter run                        # Run on device/emulator
flutter run --release              # Release build
```

### Testing
```bash
flutter test                       # Run all tests
flutter test --coverage            # With coverage report
flutter test test/presentation/    # Run specific test directory
```

### Code Quality
```bash
flutter analyze                    # Static analysis
dart format lib test               # Format code (must pass in CI)
```

### Build Artifacts
```bash
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android App Bundle (for Play Store)
```

## CI/CD Pipeline (GitHub Actions)

Workflow triggers on push/PR to `main` or `develop`:
1. **Analyze Job**: Format check + flutter analyze
2. **Test Job**: Run all tests with coverage, upload to Codecov
3. **Build Android Job**: Build release APK (all branches)
4. **Build App Bundle Job**: Build AAB (main branch only)

Artifacts are uploaded to GitHub Actions for download.

## Codebase Conventions

### File Organization
- Domain entities are pure Dart (no Flutter imports)
- Data models extend entities and handle JSON
- BLoC files split into `_event.dart`, `_state.dart`, `_bloc.dart`
- Reusable widgets in `presentation/widgets/` (stateless, accept callbacks)

### Error Handling
- Domain: `Either<Failure, T>` from `dartz` package
- Data: Throw typed exceptions (`ServerException`, `NetworkException`)
- Repository: Catch exceptions, return `Left(Failure)`
- Presentation: BLoC emits `PostError` state with message

### Testing Strategy
- Unit tests: BLoC logic (`bloc_test`), model serialization
- Mocks: Use `mocktail` for use cases and repositories
- Widget tests: Basic smoke test in `test/widget_test.dart`

### API Integration
- Base URL in `lib/core/utils/constants.dart`
- HTTP client wrapped in `lib/core/network/api_client.dart`
- All requests return JSON or throw typed exception

## Guidance for AI Agents Working Here

### Adding New Features
1. Start in domain: define entity, repository contract, use case
2. Implement data layer: model with `fromJson`/`toJson`, data source, repository impl
3. Build presentation: BLoC events/states, page, reusable widgets
4. Register in `injection_container.dart`
5. Write tests: BLoC test with mock use case, model serialization test

### Modifying Existing Features
- Keep domain pure (no external dependencies except `equatable`, `dartz`)
- Data models must extend domain entities
- BLoC never contains UI logic (keep in widgets)
- Maintain separation: presentation imports domain, data imports domain, presentation never imports data

### Environment Setup
- Dart SDK: `^3.8.1` (defined in `pubspec.yaml`)
- Flutter version in CI: `3.24.0` (update `.github/workflows/ci-cd.yml` if needed)
- Android namespace: `com.bloccicd.bloccicd`
- Java/Kotlin target: 11

### Best Practices
- Use `const` constructors for immutable widgets and entities
- BLoC state classes extend `Equatable` for comparison
- API calls wrapped in try-catch at repository level
- Pull-to-refresh implemented via `RefreshIndicator` + `RefreshPostsEvent`
- Format code before committing (CI will fail on format errors)


