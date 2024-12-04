import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/domain/get_tv_series_recommendations.dart';
import 'package:tv_series/presentation/bloc/recommendation/recommendation_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../detail/detail_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendations])
void main() {
  late RecommendationTvSeriesBloc recommendationTvSeriesBloc;
  late MockGetTvSeriesRecommendations mockGetRecommendationTvSeries;

  setUp(() {
    mockGetRecommendationTvSeries = MockGetTvSeriesRecommendations();
    recommendationTvSeriesBloc =
        RecommendationTvSeriesBloc(mockGetRecommendationTvSeries);
  });

  const testId = 1;
  final testTvSeriesList = <TvSeries>[testTvSeries];

  test('initial state should be empty', () {
    expect(recommendationTvSeriesBloc.state, RecommendationTvSeriesEmpty());
  });

  blocTest<RecommendationTvSeriesBloc, RecommendationTvSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetRecommendationTvSeries.execute(testId))
          .thenAnswer((_) async => Right(testTvSeriesList));
      return recommendationTvSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationTvSeries(testId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      RecommendationTvSeriesLoading(),
      RecommendationTvSeriesHasData(testTvSeriesList),
    ],
    verify: (bloc) => verify(mockGetRecommendationTvSeries.execute(testId)),
  );

  blocTest<RecommendationTvSeriesBloc, RecommendationTvSeriesState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetRecommendationTvSeries.execute(testId))
          .thenAnswer((_) async => const Right([]));
      return recommendationTvSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationTvSeries(testId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      RecommendationTvSeriesLoading(),
      RecommendationTvSeriesEmpty(),
    ],
    verify: (bloc) => verify(mockGetRecommendationTvSeries.execute(testId)),
  );

  blocTest<RecommendationTvSeriesBloc, RecommendationTvSeriesState>(
    'Should emit [Loading, Error] when get recommendations tv series is unsuccessful',
    build: () {
      when(mockGetRecommendationTvSeries.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return recommendationTvSeriesBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationTvSeries(testId)),
    expect: () => [
      RecommendationTvSeriesLoading(),
      const RecommendationTvSeriesError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetRecommendationTvSeries.execute(testId)),
  );
}