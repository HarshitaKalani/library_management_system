// This is a basic Flutter applicataion test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loginapp/main.dart' as app;
import 'package:loginapp/main.dart';

void main() {
  testWidgets('Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await Firebase.initializeApp();
    // app.main();
    print("here");
    await tester.pumpWidget(HomePage());

    //Verify bottom modal sheet
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);

    //Verify logout
    await tester.tap(find.byIcon(Icons.logout));
    expect(find.text('Logout Alert!!'), findsOneWidget);
    // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  }, timeout: Timeout.none);
}
