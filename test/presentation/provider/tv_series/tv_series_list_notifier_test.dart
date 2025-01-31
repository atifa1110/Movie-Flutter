import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingTvSeries,
  GetPopularTvSeries,
  GetTopRatedTvSeries]
)
void main() {
  late TvSeriesListNotifier provider;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    mockGetPopularTvSeries= MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider = TvSeriesListNotifier(
        getNowPlayingTvSeries: mockGetNowPlayingTvSeries,
        getPopularTvSeries: mockGetPopularTvSeries,
        getTopRatedTvSeries: mockGetTopRatedTvSeries
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final testTvList = <TvSeries>[testTvSeries];

  group('now playing tv series', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchNowPlayingTvSeries();
      // assert
      verify(mockGetNowPlayingTvSeries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchNowPlayingTvSeries();
      // assert
      expect(provider.nowPlayingState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      await provider.fetchNowPlayingTvSeries();
      // assert
      expect(provider.nowPlayingState, RequestState.Loaded);
      expect(provider.nowPlayingTvSeries, testTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchNowPlayingTvSeries();
      // assert
      expect(provider.nowPlayingState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change movies data when data is gotten successfully', () async {
          // arrange
          when(mockGetPopularTvSeries.execute())
              .thenAnswer((_) async => Right(testTvList));
          // act
          await provider.fetchPopularTvSeries();
          // assert
          expect(provider.popularState, RequestState.Loaded);
          expect(provider.popularTvSeries, testTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      // act
      provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully', () async {
          // arrange
          when(mockGetTopRatedTvSeries.execute())
              .thenAnswer((_) async => Right(testTvList));
          // act
          await provider.fetchTopRatedTvSeries();
          // assert
          expect(provider.topRatedState, RequestState.Loaded);
          expect(provider.topRatedTvSeries, testTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

}
