# Testing Guide

This document provides comprehensive information about testing in the BlocCI/CD Flutter application.

## Test Structure

```
test/
├── data/
│   └── models/
│       └── post_model_test.dart        # Model serialization tests
├── presentation/
│   └── bloc/
│       └── post_bloc_test.dart         # BLoC logic tests
└── widget_test.dart                     # Widget/integration tests
```

## Testing Strategy

### 1. Unit Tests
Test individual units of code (functions, methods, classes) in isolation.

**Example: PostModel serialization test**
```dart
test('should return a valid model from JSON', () {
  final Map<String, dynamic> jsonMap = {...};
  final result = PostModel.fromJson(jsonMap);
  expect(result, equals(tPostModel));
});
```

### 2. BLoC Tests
Test BLoC state management logic using `bloc_test` package.

**Example: PostBloc test**
```dart
blocTest<PostBloc, PostState>(
  'should emit [PostLoading, PostLoaded] when data is fetched',
  build: () {
    when(() => mockGetPosts()).thenAnswer((_) async => Right(tPosts));
    return postBloc;
  },
  act: (bloc) => bloc.add(LoadPostsEvent()),
  expect: () => [PostLoading(), PostLoaded(tPosts)],
);
```

### 3. Widget Tests
Test widget UI and interactions.

**Example: App initialization test**
```dart
testWidgets('App should build and show Posts title', (tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.text('Posts'), findsOneWidget);
});
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/presentation/bloc/post_bloc_test.dart
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run tests in watch mode (auto-rerun on changes)
```bash
flutter test --watch
```

### Run tests with verbose output
```bash
flutter test --verbose
```

## Test Coverage

### Generate coverage report
```bash
flutter test --coverage
```

### View coverage (requires lcov)
```bash
# macOS
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

### Coverage goals
- **Unit tests**: 80%+ coverage
- **BLoC tests**: 100% coverage (all states and events)
- **Widget tests**: Critical user flows

## Mocking

We use `mocktail` for creating test doubles.

### Creating a mock
```dart
class MockPostRepository extends Mock implements PostRepository {}
class MockGetPosts extends Mock implements GetPosts {}
```

### Using mocks
```dart
// Setup
final mockGetPosts = MockGetPosts();
when(() => mockGetPosts()).thenAnswer((_) async => Right(tPosts));

// Verify
verify(() => mockGetPosts()).called(1);
```

## Writing Tests

### Test Naming Convention
```dart
group('ClassName', () {
  group('methodName', () {
    test('should do something when condition', () {
      // Test implementation
    });
  });
});
```

### AAA Pattern (Arrange, Act, Assert)
```dart
test('should return PostModel from JSON', () {
  // Arrange
  final json = {'id': 1, 'title': 'Test'};
  
  // Act
  final result = PostModel.fromJson(json);
  
  // Assert
  expect(result.id, equals(1));
  expect(result.title, equals('Test'));
});
```

## Testing Best Practices

### 1. Test Independence
Each test should be independent and not rely on other tests.

### 2. Use Test Data
Create constant test data at the top of test files:
```dart
const tPost = Post(id: 1, userId: 1, title: 'Test', body: 'Test');
const tPosts = [tPost];
```

### 3. Test Edge Cases
- Empty lists
- Null values (if applicable)
- Error conditions
- Boundary values

### 4. Descriptive Test Names
```dart
// Good
test('should emit PostError when repository throws ServerException', () {});

// Bad
test('test error', () {});
```

### 5. One Assertion per Test (when possible)
```dart
// Prefer
test('should have correct id', () {
  expect(result.id, equals(1));
});

test('should have correct title', () {
  expect(result.title, equals('Test'));
});

// Over
test('should have correct properties', () {
  expect(result.id, equals(1));
  expect(result.title, equals('Test'));
});
```

## BLoC Testing Guidelines

### Test all events
```dart
blocTest<PostBloc, PostState>(
  'LoadPostsEvent should load posts',
  build: () => postBloc,
  act: (bloc) => bloc.add(LoadPostsEvent()),
  expect: () => [PostLoading(), PostLoaded(tPosts)],
);

blocTest<PostBloc, PostState>(
  'RefreshPostsEvent should refresh posts',
  build: () => postBloc,
  act: (bloc) => bloc.add(RefreshPostsEvent()),
  expect: () => [PostLoaded(tPosts)],
);
```

### Test all state transitions
- Initial → Loading → Loaded
- Initial → Loading → Error
- Loaded → Loaded (refresh)

### Verify interactions
```dart
verify(() => mockGetPosts()).called(1);
verifyNever(() => mockGetPosts());
```

## Widget Testing Guidelines

### Pump and settle
```dart
// Pump: trigger a frame
await tester.pump();

// PumpAndSettle: wait for all animations to complete
await tester.pumpAndSettle();

// PumpWidget: build widget
await tester.pumpWidget(MyWidget());
```

### Finding widgets
```dart
// By text
find.text('Posts')

// By key
find.byKey(Key('post-card'))

// By type
find.byType(PostCard)

// By icon
find.byIcon(Icons.refresh)
```

### Interacting with widgets
```dart
// Tap
await tester.tap(find.byIcon(Icons.refresh));
await tester.pump();

// Enter text
await tester.enterText(find.byType(TextField), 'Hello');

// Scroll
await tester.drag(find.byType(ListView), Offset(0, -300));
```

## Testing Recipes

### Testing API calls
```dart
test('should call API with correct endpoint', () async {
  // Arrange
  when(() => mockApiClient.get('/posts'))
    .thenAnswer((_) async => mockResponse);
  
  // Act
  await dataSource.getPosts();
  
  // Assert
  verify(() => mockApiClient.get('/posts')).called(1);
});
```

### Testing error handling
```dart
test('should return ServerFailure when server throws exception', () async {
  // Arrange
  when(() => mockDataSource.getPosts())
    .thenThrow(ServerException('Server error'));
  
  // Act
  final result = await repository.getPosts();
  
  // Assert
  expect(result, Left(ServerFailure('Server error')));
});
```

### Testing JSON parsing
```dart
test('should parse JSON correctly', () {
  // Arrange
  final json = {'id': 1, 'title': 'Test'};
  
  // Act
  final model = PostModel.fromJson(json);
  
  // Assert
  expect(model.id, 1);
  expect(model.title, 'Test');
});
```

## Continuous Integration

Tests run automatically on:
- Push to `main` or `develop`
- Pull requests

See `.github/workflows/ci-cd.yml` for CI configuration.

### CI Test Steps:
1. Checkout code
2. Setup Flutter
3. Get dependencies
4. Run tests with coverage
5. Upload coverage to Codecov

## Troubleshooting

### Tests timing out
Increase timeout:
```dart
testWidgets('test', (tester) async {
  // Test code
}, timeout: Timeout(Duration(seconds: 30)));
```

### Async tests not completing
Ensure you `await` all futures:
```dart
await repository.getPosts(); // Don't forget await!
```

### Mock not working
Register fallback values for custom types:
```dart
setUpAll(() {
  registerFallbackValue(FakePost());
});
```

### Widget not rebuilding
Use `pump()` or `pumpAndSettle()`:
```dart
await tester.tap(find.byIcon(Icons.add));
await tester.pump(); // Trigger rebuild
```

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [bloc_test Package](https://pub.dev/packages/bloc_test)
- [mocktail Package](https://pub.dev/packages/mocktail)
- [Flutter Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)

## Coverage Report Example

```
File                                       % Lines
lib/core/error/exceptions.dart              100.0%
lib/core/error/failures.dart                100.0%
lib/data/models/post_model.dart             100.0%
lib/presentation/bloc/post_bloc.dart        100.0%
lib/presentation/bloc/post_state.dart       100.0%
lib/presentation/bloc/post_event.dart       100.0%
----------------------------------------
Total Coverage                               85.5%
```

## Next Steps

1. Add integration tests for user flows
2. Add golden tests for UI consistency
3. Add performance tests
4. Set up automated visual regression testing

