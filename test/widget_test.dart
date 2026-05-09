import 'package:flutter_test/flutter_test.dart';
import 'package:bloccicd/main.dart';
import 'package:bloccicd/injection_container.dart';

void main() {
  setUpAll(() async {
    // Initialize dependencies before tests
    await initializeDependencies();
  });

  testWidgets('App should build and show Posts title', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify that the app bar title is present
    expect(find.text('Posts'), findsOneWidget);
  });
}
