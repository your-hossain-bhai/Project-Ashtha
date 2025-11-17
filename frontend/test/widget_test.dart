import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:krishokdhoni/main.dart';
import 'package:krishokdhoni/providers/auth_provider.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
        child: const MyApp(),
      ),
    );

    // Verify that the splash screen is shown
    expect(find.text('কৃষকধনী'), findsOneWidget);
    expect(find.text('Empowering Farmers'), findsOneWidget);
  });
}
