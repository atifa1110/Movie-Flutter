import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Test - Home Page Navigation', (){
    testWidgets('Navigate through drawer and verify tabs', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify "Ditonton" is in the AppBar of the Home Page
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Ditonton'), findsOneWidget);

      //Open the drawer
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pump(const Duration(seconds: 2));

      // Navigate to TV Series Page
      await tester.tap(find.byKey(const Key('drawer_tv_tile')));
      await tester.pump(const Duration(seconds: 2));

      // Verify TV Series Page is displayed
      expect(find.text('Tv Series'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      // Tap the Back Button
      await tester.tap(find.byTooltip('Back'));
      await tester.pump(const Duration(seconds: 1));

      // Navigate to Watchlist Page
      await tester.tap(find.byKey(const Key('drawer_watchlist_tile')));
      await tester.pump(const Duration(seconds: 2));

      // Verify Watchlist Page is displayed
      expect(find.text('Watchlist Movies'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      // Tap the Back Button
      await tester.tap(find.byTooltip('Back'));
      await tester.pump(const Duration(seconds: 1));

      // Navigate to About Page
      await tester.tap(find.byKey(const Key('drawer_about_tile')));
      await tester.pump(const Duration(seconds: 2));
    });

  });
}