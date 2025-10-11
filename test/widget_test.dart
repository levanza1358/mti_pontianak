import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:mti_pontianak/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Pump the main app
    await tester.pumpWidget(const MyApp());

    // Ensure the root GetMaterialApp is present
    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
