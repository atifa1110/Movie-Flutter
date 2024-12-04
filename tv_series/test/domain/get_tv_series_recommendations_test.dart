import 'package:core/domain/entities/tv_series.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/get_tv_series_recommendations.dart';

import '../helper/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendations(mockTvSeriesRepository);
  });

  final testId = 1;
  final testTv = <TvSeries>[];

  test('should get list of tv series recommendations from the repository',
          () async {
        // arrange
        when(mockTvSeriesRepository.getTvSeriesRecommendations(testId))
            .thenAnswer((_) async => Right(testTv));
        // act
        final result = await usecase.execute(testId);
        // assert
        expect(result, Right(testTv));
      });
}
