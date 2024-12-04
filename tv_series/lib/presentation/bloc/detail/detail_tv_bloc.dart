import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/domain/get_tv_series_detail.dart';
import 'package:tv_series/domain/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/save_watchlist_tv_series.dart';

part 'detail_tv_state.dart';
part 'detail_tv_event.dart';

class DetailTvSeriesBloc extends Bloc<DetailTvSeriesEvent, DetailTvSeriesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;
  final GetWatchListStatusTvSeries getWatchListStatusTvSeries;

  DetailTvSeriesBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
    required this.getWatchListStatusTvSeries,
  }) : super(DetailTvSeriesState.initial()) {
    on<FetchDetailTvSeries>((event, emit) async {
      emit(state.copyWith(tvSeriesDetailState: RequestState.Loading));

      final id = event.id;

      final detailTvSeriesResult = await getTvSeriesDetail.execute(id);
      final recommendationTvSeriesResult = await getTvSeriesRecommendations.execute(id);

      detailTvSeriesResult.fold(
            (failure) => emit(
          state.copyWith(
            tvSeriesDetailState: RequestState.Error,
            message: failure.message,
          ),
        ),
            (tvSeriesDetail) {
          emit(
            state.copyWith(
              tvSeriesRecommendationsState: RequestState.Loading,
              tvSeriesDetailState: RequestState.Loaded,
              tvSeriesDetail: tvSeriesDetail,
            ),
          );
          recommendationTvSeriesResult.fold(
                (failure) => emit(
              state.copyWith(
                tvSeriesRecommendationsState: RequestState.Error,
                message: failure.message,
              ),
            ),
                (tvSeriesRecommendations) {
              if (tvSeriesRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    tvSeriesRecommendationsState: RequestState.Empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    tvSeriesRecommendationsState: RequestState.Loaded,
                    tvSeriesRecommendations: tvSeriesRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    on<AddWatchlistTvSeries>((event, emit) async {
      final tvDetail = event.tvSeriesDetail;
      final result = await saveWatchlistTvSeries.execute(tvDetail);

      result.fold(
            (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
            (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTvSeries(tvDetail.id));
    });

    on<RemoveFromWatchlistTvSeries>((event, emit) async {
      final tvDetail = event.tvSeriesDetail;
      final result = await removeWatchlistTvSeries.execute(tvDetail);

      result.fold(
            (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
            (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTvSeries(tvDetail.id));
    });

    on<LoadWatchlistStatusTvSeries>((event, emit) async {
      final status = await getWatchListStatusTvSeries.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}