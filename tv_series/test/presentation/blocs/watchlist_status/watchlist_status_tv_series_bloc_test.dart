import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/save_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/watchlist_status/watchlist_status_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../detail/detail_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late WatchlistStatusTvSeriesBloc watchlistStatusTvSeriesBloc;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatusTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetWatchListStatusTvSeries = MockGetWatchListStatusTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    watchlistStatusTvSeriesBloc = WatchlistStatusTvSeriesBloc(
      getWatchListStatusTvSeries: mockGetWatchListStatusTvSeries,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
    );
  });

  const testId = 1;

  group('Watchlist Status TV Series', () {
    blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
      'Should emit [WatchlistStatusState] when get watchlist status true',
      build: () {
        when(mockGetWatchListStatusTvSeries.execute(testId)).thenAnswer((_) async => true);
        return watchlistStatusTvSeriesBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTvSeries(testId)),
      expect: () => [
        const WatchlistStatusTvSeriesState(
            isAddedToWatchlist: true, message: ''),
      ],
    );
  });

  group('Save Watchlist TV Series', () {
    blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
      'Should emit [WatchlistStatusState] when data is saved',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatusTvSeries.execute(testId))
            .thenAnswer((_) async => true);
        return watchlistStatusTvSeriesBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        const WatchlistStatusTvSeriesState(
          isAddedToWatchlist: true,
          message: 'Added to Watchlist',
        ),
      ],
      verify: (bloc) => [
        verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)),
        verify(mockGetWatchListStatusTvSeries.execute(testId)),
      ],
    );

    blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
      'Should emit [WatchlistStatusState] when save data is unsuccessful',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer(
                (_) async => Left(DatabaseFailure('Failed Added to Watchlist')));
        when(mockGetWatchListStatusTvSeries.execute(testId))
            .thenAnswer((_) async => false);
        return watchlistStatusTvSeriesBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        const WatchlistStatusTvSeriesState(
          isAddedToWatchlist: false,
          message: 'Failed Added to Watchlist',
        ),
      ],
      verify: (bloc) => [
        verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail)),
        verify(mockGetWatchListStatusTvSeries.execute(testId)),
      ],
    );
  });

  group('Remove Watchlist TV Series', () {
    blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
      'Should emit [WatchlistStatusState] when data is removed',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatusTvSeries.execute(testId))
            .thenAnswer((_) async => false);
        return watchlistStatusTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        const WatchlistStatusTvSeriesState(
          isAddedToWatchlist: false,
          message: 'Removed from Watchlist',
        ),
      ],
      verify: (bloc) => [
        verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail)),
        verify(mockGetWatchListStatusTvSeries.execute(testId)),
      ],
    );

    blocTest<WatchlistStatusTvSeriesBloc, WatchlistStatusTvSeriesState>(
      'Should emit [WatchlistStatusState] when remove data is unsuccessful',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail)).thenAnswer(
                (_) async => Left(DatabaseFailure('Failed Removed from Watchlist')));
        when(mockGetWatchListStatusTvSeries.execute(testId))
            .thenAnswer((_) async => true);
        return watchlistStatusTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        const WatchlistStatusTvSeriesState(
          isAddedToWatchlist: true,
          message: 'Failed Removed from Watchlist',
        ),
      ],
      verify: (bloc) => [
        verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail)),
        verify(mockGetWatchListStatusTvSeries.execute(testId)),
      ],
    );
  });
}