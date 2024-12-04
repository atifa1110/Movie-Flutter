import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/get_tv_series_detail.dart';
import 'package:tv_series/domain/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/save_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/detail/detail_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late DetailTvSeriesBloc detailTvSeriesBloc;
  late MockGetTvSeriesDetail mockGetDetailTvSeries;
  late MockGetTvSeriesRecommendations mockGetRecommendationTvSeries;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatusTvSeries;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetDetailTvSeries = MockGetTvSeriesDetail();
    mockGetRecommendationTvSeries = MockGetTvSeriesRecommendations();
    mockGetWatchListStatusTvSeries = MockGetWatchListStatusTvSeries();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    detailTvSeriesBloc = DetailTvSeriesBloc(
        getTvSeriesDetail: mockGetDetailTvSeries,
        getTvSeriesRecommendations: mockGetRecommendationTvSeries,
        saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
        removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
        getWatchListStatusTvSeries: mockGetWatchListStatusTvSeries
    );
  });

  const tId = 1;
  final testTvSeriesList = <TvSeries>[testTvSeries];

  group('Get Detail Tv Series', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [DetailTvLoading, DetailTvLoaded, RecommendationLoading, RecommendationLoaded] when get detail tv and recommendation tv success',
      build: () {
        when(mockGetDetailTvSeries.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetRecommendationTvSeries.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.Loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesRecommendationsState: RequestState.Loading,
          tvSeriesDetailState: RequestState.Loaded,
          tvSeriesDetail: testTvSeriesDetail,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.Loaded,
          tvSeriesDetail: testTvSeriesDetail,
          tvSeriesRecommendationsState: RequestState.Loaded,
          tvSeriesRecommendations: testTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(mockGetDetailTvSeries.execute(tId));
        verify(mockGetRecommendationTvSeries.execute(tId));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [DetailTvError] when get detail tv failed',
      build: () {
        when(mockGetDetailTvSeries.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetRecommendationTvSeries.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.Loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetDetailTvSeries.execute(tId));
        verify(mockGetRecommendationTvSeries.execute(tId));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [DetailTvLoading, DetailTvLoaded, RecommendationEmpty] when get recommendation tv empty',
      build: () {
        when(mockGetDetailTvSeries.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetRecommendationTvSeries.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.Loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesRecommendationsState: RequestState.Loading,
          tvSeriesDetailState: RequestState.Loaded,
          tvSeriesDetail: testTvSeriesDetail,
        ),
      ],
      verify: (_) {
        verify(mockGetDetailTvSeries.execute(tId));
        verify(mockGetRecommendationTvSeries.execute(tId));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [DetailMovieLoading, RecommendationLoading, DetailMovieLoaded, RecommendationError] when get recommendation failed',
      build: () {
        when(mockGetDetailTvSeries.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetRecommendationTvSeries.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.Loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesRecommendationsState: RequestState.Loading,
          tvSeriesDetailState: RequestState.Loaded,
          tvSeriesDetail: testTvSeriesDetail,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.Loaded,
          tvSeriesDetail: testTvSeriesDetail,
          tvSeriesRecommendationsState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetDetailTvSeries.execute(tId));
        verify(mockGetRecommendationTvSeries.execute(tId));
      },
    );
  });

  group('Load Watchlist Status Tv Series', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistStatus] is true',
      build: () {
        when(mockGetWatchListStatusTvSeries.execute(tId))
            .thenAnswer((_) async => true);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatusTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => verify(mockGetWatchListStatusTvSeries.execute(tId)),
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistStatus] is false',
      build: () {
        when(mockGetWatchListStatusTvSeries.execute(tId))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatusTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => verify(mockGetWatchListStatusTvSeries.execute(tId)),
    );
  });

  group('Added To WatchlistTv Series', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shou;d emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id));
      },
    );
  });

  group('Remove From Watchlist Tv Series', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Shoud emit [WatchlistMessage] when failed removed from watchlist',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchListStatusTvSeries.execute(testTvSeriesDetail.id));
      },
    );
  });
}