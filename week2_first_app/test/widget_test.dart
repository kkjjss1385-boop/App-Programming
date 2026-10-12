import 'package:flutter_test/flutter_test.dart';
import 'package:week_4_hello_app/main.dart';

void main() {
  testWidgets('shows calculator display', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);
  });
}
