part of 'detail_tv_bloc.dart';

class DetailTvSeriesState extends Equatable {
  final TvSeriesDetail? tvSeriesDetail;
  final RequestState tvSeriesDetailState;
  final List<TvSeries> tvSeriesRecommendations;
  final RequestState tvSeriesRecommendationsState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const DetailTvSeriesState({
    required this.tvSeriesDetail,
    required this.tvSeriesDetailState,
    required this.tvSeriesRecommendations,
    required this.tvSeriesRecommendationsState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object?> get props {
    return [
      tvSeriesDetail,
      tvSeriesDetailState,
      tvSeriesRecommendations,
      tvSeriesRecommendationsState,
      message,
      watchlistMessage,
      isAddedToWatchlist,
    ];
  }

  DetailTvSeriesState copyWith({
    TvSeriesDetail? tvSeriesDetail,
    RequestState? tvSeriesDetailState,
    List<TvSeries>? tvSeriesRecommendations,
    RequestState? tvSeriesRecommendationsState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return DetailTvSeriesState(
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      tvSeriesDetailState: tvSeriesDetailState ?? this.tvSeriesDetailState,
      tvSeriesRecommendations: tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      tvSeriesRecommendationsState: tvSeriesDetailState ?? this.tvSeriesRecommendationsState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory DetailTvSeriesState.initial() {
    return const DetailTvSeriesState(
      tvSeriesDetail: null,
      tvSeriesDetailState: RequestState.Empty,
      tvSeriesRecommendations: [],
      tvSeriesRecommendationsState: RequestState.Empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }
}