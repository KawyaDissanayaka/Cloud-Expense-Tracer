import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_expense_tracer/main.dart';

void main() {
  testWidgets('App builds successfully smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    
    // The app starts on loading or auth screen
    expect(find.byType(MyApp), findsOneWidget);
  });
}
