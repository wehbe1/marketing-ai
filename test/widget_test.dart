import 'package:flutter_test/flutter_test.dart';
import 'package:marketing_ai/main.dart';

void main() {
  testWidgets('Shows language selection screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MarketingAIApp());

    // בודק שמופיע טקסט מסך הבחירה הראשוני
    expect(find.text('בחר שפה / Choose language'), findsOneWidget);
  });
}
