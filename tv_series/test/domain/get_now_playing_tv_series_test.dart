import 'package:core/domain/entities/tv_series.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/get_now_playing_tv_series.dart';

import '../helper/test_helper.mocks.dart';

void main() {
  late MockTvSeriesRepository mockTvSeriesRepository;
  late GetNowPlayingTvSeries usecase;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetNowPlayingTvSeries(mockTvSeriesRepository);
  });

  final testTvSeries = <TvSeries>[];

  test('should get list of now playing tv series from the repository', () async {
        // arrange
        when(mockTvSeriesRepository.getNowPlayingTvSeries())
            .thenAnswer((_) async => Right(testTvSeries));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(testTvSeries));
      });
}