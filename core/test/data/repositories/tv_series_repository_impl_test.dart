import 'dart:io';
import 'package:core/data/models/tv_series_model.dart';
import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_series/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final testTvSeriesModelList = <TvSeriesModel>[testTvSeriesModel];
  final testTvSeriesList = <TvSeries>[testTvSeries];

  group('Now Playing TV Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvSeries())
              .thenAnswer((_) async => testTvSeriesModelList);
          // act
          final result = await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          final resultList = result.getOrElse(() => []);
          expect(resultList, testTvSeriesList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingTvSeries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getNowPlayingTvSeries();
          // assert
          verify(mockRemoteDataSource.getNowPlayingTvSeries());
          expect(
            result,
            equals(Left(ConnectionFailure('Failed to connect to the network'))),
          );
        });
  });

  group('Popular TV Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenAnswer((_) async => testTvSeriesModelList);
          // act
          final result = await repository.getPopularTvSeries();
          // assert
          verify(mockRemoteDataSource.getPopularTvSeries());
          final resultList = result.getOrElse(() => []);
          expect(resultList, testTvSeriesList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getPopularTvSeries();
          // assert
          verify(mockRemoteDataSource.getPopularTvSeries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getPopularTvSeries();
          // assert
          verify(mockRemoteDataSource.getPopularTvSeries());
          expect(
            result,
            equals(Left(ConnectionFailure('Failed to connect to the network'))),
          );
        });
  });

  group('Top Rated TV Series', () {
    test('should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvSeries())
              .thenAnswer((_) async => testTvSeriesModelList);
          // act
          final result = await repository.getTopRatedTvSeries();
          // assert
          verify(mockRemoteDataSource.getTopRatedTvSeries());
          final resultList = result.getOrElse(() => []);
          expect(resultList, testTvSeriesList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvSeries())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTopRatedTvSeries();
          // assert
          verify(mockRemoteDataSource.getTopRatedTvSeries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedTvSeries()).thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedTvSeries();
          // assert
          verify(mockRemoteDataSource.getTopRatedTvSeries());
          expect(
            result,
            equals(Left(ConnectionFailure('Failed to connect to the network'))),
          );
        });
  });

  group('Search TV Series', () {
    final tQuery = 'game of thrones';

    test('should return tv series list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenAnswer((_) async => testTvSeriesModelList);
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, testTvSeriesList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Get TV Series Detail', () {
    final testId = 1;

    test(
        'should return TV Series data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesDetail(testId))
              .thenAnswer((_) async => testTvSeriesResponse);
          // act
          final result = await repository.getTvSeriesDetail(testId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesDetail(testId));
          expect(result, equals(Right(testTvSeriesDetail)));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesDetail(testId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvSeriesDetail(testId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesDetail(testId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesDetail(testId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvSeriesDetail(testId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesDetail(testId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get TV Series Recommendations', () {
    final tTvSeriesList = <TvSeriesModel>[];
    final testId = 1;

    test('should return data (tv series list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesRecommendations(testId))
              .thenAnswer((_) async => tTvSeriesList);
          // act
          final result = await repository.getTvSeriesRecommendations(testId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesRecommendations(testId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTvSeriesList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesRecommendations(testId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvSeriesRecommendations(testId);
          // assertbuild runner
          verify(mockRemoteDataSource.getTvSeriesRecommendations(testId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesRecommendations(testId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvSeriesRecommendations(testId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesRecommendations(testId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);
      // act
      final result = await repository.getWatchlistTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}