import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:movies/domain/get_movie_detail.dart';
import 'package:movies/domain/get_movie_recommendations.dart';
import 'package:movies/domain/get_watchlist_status.dart';
import 'package:movies/domain/remove_watchlist.dart';
import 'package:movies/domain/save_watchlist.dart';

part 'detail_movies_state.dart';
part 'detail_movies_event.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getDetailMovie;
  final GetMovieRecommendations getRecommendationMovies;
  final SaveWatchlist saveWatchlistMovie;
  final RemoveWatchlist removeWatchlistMovie;
  final GetWatchListStatus getWatchListStatusMovie;

  DetailMovieBloc({
    required this.getDetailMovie,
    required this.getRecommendationMovies,
    required this.saveWatchlistMovie,
    required this.removeWatchlistMovie,
    required this.getWatchListStatusMovie,
  }) : super(DetailMovieState.initial()) {
    on<FetchDetailMovie>((event, emit) async {
      emit(state.copyWith(movieDetailState: RequestState.Loading));

      final id = event.id;

      final detailMovieResult = await getDetailMovie.execute(id);
      final recommendationMoviesResult = await getRecommendationMovies.execute(id);

      detailMovieResult.fold(
            (failure) => emit(
          state.copyWith(
            movieDetailState: RequestState.Error,
            message: failure.message,
          ),
        ),
            (movieDetail) {
          emit(
            state.copyWith(
              movieRecommendationsState: RequestState.Loading,
              movieDetailState: RequestState.Loaded,
              movieDetail: movieDetail,
            ),
          );
          recommendationMoviesResult.fold(
                (failure) => emit(
              state.copyWith(
                movieRecommendationsState: RequestState.Error,
                message: failure.message,
              ),
            ),
                (movieRecommendations) {
              if (movieRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    movieRecommendationsState: RequestState.Empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    movieRecommendationsState: RequestState.Loaded,
                    movieRecommendations: movieRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    on<AddWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await saveWatchlistMovie.execute(movieDetail);

      result.fold(
            (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
            (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusMovie(movieDetail.id));
    });

    on<RemoveFromWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await removeWatchlistMovie.execute(movieDetail);

      result.fold(
            (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
            (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusMovie(movieDetail.id));
    });

    on<LoadWatchlistStatusMovie>((event, emit) async {
      final status = await getWatchListStatusMovie.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}