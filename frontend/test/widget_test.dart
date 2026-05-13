import 'package:flutter_test/flutter_test.dart';
import 'package:regional_calendar_app/main.dart';

void main() {
	testWidgets('App should render without errors', (WidgetTester tester) async {
		await tester.pumpWidget(const RegionalCalendarApp());
		await tester.pumpAndSettle();
		expect(find.text('节日历'), findsOneWidget);
	});
}
