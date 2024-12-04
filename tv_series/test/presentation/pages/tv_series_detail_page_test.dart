import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/detail/detail_tv_bloc.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';
import '../../dummy_data/dummy_objects.dart';

class MockDetailTvSeriesBLoc extends MockBloc<DetailTvSeriesEvent, DetailTvSeriesState>
    implements DetailTvSeriesBloc {}

class FakeDetailTvEvent extends Fake implements DetailTvSeriesEvent {}

class FakeDetailTvState extends Fake implements DetailTvSeriesEvent {}

void main() {
  late MockDetailTvSeriesBLoc mockDetailTvSeriesBLoc;

  setUpAll(() {
    registerFallbackValue(FakeDetailTvEvent());
    registerFallbackValue(FakeDetailTvState());
  });

  setUp(() {
    mockDetailTvSeriesBLoc = MockDetailTvSeriesBLoc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<DetailTvSeriesBloc>.value(
      value: mockDetailTvSeriesBLoc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockDetailTvSeriesBLoc.state).thenReturn(
          DetailTvSeriesState.initial().copyWith(
            tvSeriesDetailState: RequestState.Loaded,
            tvSeriesDetail: testTvSeriesDetail,
            tvSeriesRecommendationsState: RequestState.Loaded,
            tvSeriesRecommendations: <TvSeries>[],
            isAddedToWatchlist: false,
          ),
        );

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: tId)));
        await tester.pump();

        await tester.tap(find.byType(FilledButton));
        await tester.pump();

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
          (WidgetTester tester) async {
        when(() => mockDetailTvSeriesBLoc.state).thenReturn(
          DetailTvSeriesState.initial().copyWith(
            tvSeriesDetailState: RequestState.Loaded,
            tvSeriesDetail: testTvSeriesDetail,
            tvSeriesRecommendationsState: RequestState.Loaded,
            tvSeriesRecommendations: [testTvSeries],
            isAddedToWatchlist: true,
          ),
        );

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: tId)));
        await tester.pump();

        await tester.tap(find.byType(FilledButton));
        await tester.pump();

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets('Show display snackbar when added to watchlist',
          (WidgetTester tester) async {
        whenListen(
          mockDetailTvSeriesBLoc,
          Stream.fromIterable([
            DetailTvSeriesState.initial().copyWith(
              isAddedToWatchlist: false,
            ),
            DetailTvSeriesState.initial().copyWith(
              isAddedToWatchlist: false,
              watchlistMessage: 'Added to Watchlist',
            ),
          ]),
          initialState: DetailTvSeriesState.initial(),
        );

        final snackbar = find.byType(SnackBar);
        final textMessage = find.text('Added to Watchlist');

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: tId)));

        expect(snackbar, findsNothing);
        expect(textMessage, findsNothing);

        await tester.pump();

        expect(snackbar, findsOneWidget);
        expect(textMessage, findsOneWidget);
      });

  testWidgets('Show display alert dialog when add to watchlist failed',
          (WidgetTester tester) async {
        whenListen(
          mockDetailTvSeriesBLoc,
          Stream.fromIterable([
            DetailTvSeriesState.initial().copyWith(
              isAddedToWatchlist: false,
            ),
            DetailTvSeriesState.initial().copyWith(
              isAddedToWatchlist: false,
              watchlistMessage: 'Failed Add to Watchlist',
            ),
          ]),
          initialState: DetailTvSeriesState.initial(),
        );

        final alertDialog = find.byType(AlertDialog);
        final textMessage = find.text('Failed Add to Watchlist');

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: tId)));

        expect(alertDialog, findsNothing);
        expect(textMessage, findsNothing);

        await tester.pump();

        expect(alertDialog, findsOneWidget);
        expect(textMessage, findsOneWidget);
      });

  testWidgets(
      'Movie detail page should display error text when no internet network',
          (WidgetTester tester) async {
        when(() => mockDetailTvSeriesBLoc.state).thenReturn(
          DetailTvSeriesState.initial().copyWith(
            tvSeriesDetailState: RequestState.Error,
            message: 'Failed to connect to the network',
          ),
        );

        final textErrorBarFinder = find.text('Failed to connect to the network');

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
        await tester.pump();

        expect(textErrorBarFinder, findsOneWidget);
      });

  testWidgets(
      'Recommendations Movies should display error text when data is empty',
          (WidgetTester tester) async {
        when(() => mockDetailTvSeriesBLoc.state).thenReturn(
          DetailTvSeriesState.initial().copyWith(
            tvSeriesDetailState: RequestState.Loaded,
            tvSeriesDetail: testTvSeriesDetail,
            tvSeriesRecommendationsState: RequestState.Empty,
            isAddedToWatchlist: false,
          ),
        );

        final textErrorBarFinder = find.text('No Recommendations');

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
        await tester.pump();

        expect(textErrorBarFinder, findsOneWidget);
      });

  testWidgets(
      'Recommendations Movies should display error text when get data is unsuccessful',
          (WidgetTester tester) async {
        when(() => mockDetailTvSeriesBLoc.state).thenReturn(
          DetailTvSeriesState.initial().copyWith(
            tvSeriesDetailState: RequestState.Loaded,
            tvSeriesDetail: testTvSeriesDetail,
            tvSeriesRecommendationsState: RequestState.Error,
            message: 'Error',
            isAddedToWatchlist: false,
          ),
        );

        final textErrorBarFinder = find.text('Error');

        await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
        await tester.pump();

        expect(textErrorBarFinder, findsOneWidget);
      });
}