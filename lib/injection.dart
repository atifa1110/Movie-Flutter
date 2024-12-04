import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_series_local_data_source.dart';
import 'package:core/data/datasources/tv_series_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/utils/ssl_pinning.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:movies/domain/get_movie_detail.dart';
import 'package:movies/domain/get_now_playing_movies.dart';
import 'package:movies/domain/get_popular_movies.dart';
import 'package:movies/domain/get_top_rated_movies.dart';
import 'package:movies/domain/get_movie_recommendations.dart';
import 'package:movies/domain/get_watchlist_movies.dart';
import 'package:movies/domain/get_watchlist_status.dart';
import 'package:movies/domain/remove_watchlist.dart';
import 'package:movies/domain/save_watchlist.dart';
import 'package:movies/domain/search_movies.dart';
import 'package:movies/presentation/blocs/detail/detail_movies_bloc.dart';
import 'package:movies/presentation/blocs/now_playing/now_playing_movies_bloc.dart';
import 'package:movies/presentation/blocs/popular/popular_movies_bloc.dart';
import 'package:movies/presentation/blocs/search/search_movies_bloc.dart';
import 'package:movies/presentation/blocs/top_rated/top_rated_movies_bloc.dart';
import 'package:movies/presentation/blocs/watchlist/watchlist_movies_bloc.dart';
import 'package:tv_series/domain/get_now_playing_tv_series.dart';
import 'package:tv_series/domain/get_popular_tv_series.dart';
import 'package:tv_series/domain/get_top_rated_tv_series.dart';
import 'package:tv_series/domain/get_tv_series_detail.dart';
import 'package:tv_series/domain/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/get_watchlist_tv_series.dart';
import 'package:tv_series/domain/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/save_watchlist_tv_series.dart';
import 'package:tv_series/domain/search_tv_series.dart';
import 'package:tv_series/presentation/bloc/detail/detail_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing/now_playing_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/recommendation/recommendation_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/search/search_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist/watchlist_tv_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_status/watchlist_status_tv_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));
  locator.registerFactory(
        () => DetailMovieBloc(
      getDetailMovie: locator(),
      getRecommendationMovies: locator(),
      saveWatchlistMovie: locator(),
      removeWatchlistMovie: locator(),
      getWatchListStatusMovie: locator(),
    ),
  );
  locator.registerFactory(() => WatchlistMoviesBloc(locator()));
  locator.registerFactory(() => SearchMoviesBloc(locator()));

  // bloc tv series
  locator.registerFactory(() => NowPlayingTvSeriesBloc(locator()));
  locator.registerFactory(() => PopularTvSeriesBloc(locator()));
  locator.registerFactory(() => TopRatedTvSeriesBloc(locator()));
  locator.registerFactory(() => DetailTvSeriesBloc(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      saveWatchlistTvSeries: locator(),
      removeWatchlistTvSeries: locator(),
      getWatchListStatusTvSeries: locator()
  ),
  );
  locator.registerFactory(() => RecommendationTvSeriesBloc(locator()));
  locator.registerFactory(
        () => WatchlistStatusTvSeriesBloc(
      getWatchListStatusTvSeries: locator(),
      removeWatchlistTvSeries: locator(),
      saveWatchlistTvSeries: locator(),
    ),
  );
  locator.registerFactory(() => WatchlistTvSeriesBloc(locator()));
  locator.registerFactory(() => SearchTvSeriesBloc(locator()));

  // use case movies
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // use case tv series
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
        () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
          () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
          () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}