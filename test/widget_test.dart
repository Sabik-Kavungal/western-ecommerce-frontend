// Basic Flutter widget smoke test for MyApp.
// MyApp requires [prefs] and [navigatorKey]; the app starts at Splash (loading indicator).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e/main.dart';

void main() {
  testWidgets('MyApp smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final navKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(MyApp(prefs: prefs, navigatorKey: navKey));
    await tester.pump();
    // restoreSession finds no token and navigates to /login; one more frame to build Login
    await tester.pump();

    expect(find.text('Sign In'), findsOneWidget);
  });
}
