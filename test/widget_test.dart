// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:backup_noslq1/main.dart';

void main() {
  testWidgets('BackupScreen initial state test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BackupScreen(),
    ));

    // Verify that the app bar title is present.
    expect(find.text('Database Manager'), findsOneWidget);

    // Verify initial status text
    expect(find.text('Ready to Backup Database'), findsOneWidget);

    // Verify the backup button is present
    expect(find.text('Click to Backup Database'), findsOneWidget);

    // Verify the cloud download icon is present
    expect(find.byIcon(Icons.cloud_download), findsOneWidget);
  });
}
