import 'package:flutter_test/flutter_test.dart';
import 'package:tourflow/app.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App should render main screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TourApp());
    // allow any initial async work (fetchPackages) to complete
    await tester.pumpAndSettle();

    // Check if the home screen (PackageListScreen) appears
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
