part of 'detail_tv_bloc.dart';

abstract class DetailTvSeriesEvent extends Equatable {
  // coverage:ignore-start
  @override
  List<Object?> get props => [];
// coverage:ignore-end
}

class FetchDetailTvSeries  extends DetailTvSeriesEvent {
  final int id;

  FetchDetailTvSeries(this.id);
  // coverage:ignore-start
  @override
  List<Object?> get props => [id];
// coverage:ignore-end
}

class AddWatchlistTvSeries extends DetailTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  AddWatchlistTvSeries(this.tvSeriesDetail);
  // coverage:ignore-start
  @override
  List<Object?> get props => [tvSeriesDetail];
// coverage:ignore-end
}

class RemoveFromWatchlistTvSeries extends DetailTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  RemoveFromWatchlistTvSeries(this.tvSeriesDetail);
  // coverage:ignore-start
  @override
  List<Object?> get props => [tvSeriesDetail];
// coverage:ignore-end
}

class LoadWatchlistStatusTvSeries extends DetailTvSeriesEvent {
  final int id;

  LoadWatchlistStatusTvSeries(this.id);
  // coverage:ignore-start
  @override
  List<Object?> get props => [id];
// coverage:ignore-end
}