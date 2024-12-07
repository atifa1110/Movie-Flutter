import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;
import 'package:movies/presentation/widget/movie_card_list.dart';

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
      final drawerIcon = find.byTooltip('Open navigation menu'); // Default drawer icon tooltip
      expect(drawerIcon, findsOneWidget);
      await tester.tap(drawerIcon);
      await tester.pumpAndSettle();

      // Navigate to TV Series Page
      final tvSeriesTile = find.byKey(const Key('drawer_tv_tile'));
      expect(tvSeriesTile, findsOneWidget);
      await tester.tap(tvSeriesTile);
      await tester.pumpAndSettle();

      // Verify TV Series Page is displayed
      expect(find.text('Tv Series'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      // Tap the Back Button
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // Navigate to Watchlist Page
      final watchlistTile = find.byKey(const Key('drawer_watchlist_tile'));
      expect(watchlistTile, findsOneWidget);
      await tester.tap(watchlistTile);

      await tester.pump(const Duration(seconds: 1));

      // Verify Watchlist Page is displayed
      expect(find.text('Watchlist Movies'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));

      // Tap the Back Button
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // Navigate to About Page
      final aboutListTile = find.byKey(const Key('drawer_about_tile'));
      expect(aboutListTile, findsOneWidget);
      await tester.tap(aboutListTile);
    });

    // testWidgets('Navigate to watchlist and verify watchlist', (WidgetTester tester) async {
    //   final watchlistButton = find.byKey(Key('watchlistButton'));
    //   final iconCheck = find.byIcon(Icons.check);
    //
    //   // Launch the app
    //   app.main();
    //   await tester.pumpAndSettle();
    //
    //   // Verify "Ditonton" is in the AppBar of the Home Page
    //   await tester.pump(const Duration(seconds: 1));
    //   expect(find.text('Ditonton'), findsOneWidget);
    //   await tester.pump(const Duration(seconds: 1));
    //
    //   // Find the first movie in Now Playing section
    //   final nowPlayingMovieItem = find.byKey(Key('movie_now_playing_1'));
    //   await tester.pumpAndSettle();
    //   expect(nowPlayingMovieItem, findsOneWidget);
    //
    //   // Tap the movie item
    //   await tester.tap(nowPlayingMovieItem);
    //   await tester.pumpAndSettle();
    //
    //   // click watchlist button
    //   await tester.tap(watchlistButton);
    //   await tester.pumpAndSettle();
    //   expect(iconCheck, findsOneWidget);
    //
    //   // Tap the Back Button
    //   await tester.tap(find.byKey(Key('BackButton')));
    //   await tester.pumpAndSettle();
    //
    //   // Open the drawer
    //   final drawerIcon = find.byTooltip('Open navigation menu'); // Default drawer icon tooltip
    //   expect(drawerIcon, findsOneWidget);
    //   await tester.tap(drawerIcon);
    //   await tester.pumpAndSettle();
    //
    //   // Navigate to Watchlist Page
    //   final watchlistTile = find.byKey(const Key('drawer_watchlist_tile'));
    //   expect(watchlistTile, findsOneWidget);
    //   await tester.tap(watchlistTile);
    //   await tester.pump(const Duration(seconds: 1));
    //
    //   // Verify Watchlist Page is displayed
    //   expect(find.text('Watchlist Movies'), findsOneWidget);
    //   await tester.pumpAndSettle();
    //   expect(find.byType(MovieCard), findsOneWidget);
    // });
  });
}