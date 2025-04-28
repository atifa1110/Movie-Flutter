import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_series_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper databaseHelper;
  late Database db;

  setUp(() async {
    // Initialize the database factory for FFI (for desktop support)
    databaseFactory = databaseFactoryFfi;

    // Open an in-memory database for testing (or use a temp file)
    db = await openDatabase(
      inMemoryDatabasePath, // In-memory for quick testing
      version: 1,
      onCreate: (db, version) async {
        // Initialize the schema (create tables) for testing
        await db.execute('''
          CREATE TABLE watchlist_movies (
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            posterPath TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE watchlist_tv_series (
            id INTEGER PRIMARY KEY,
            name TEXT,
            overview TEXT,
            posterPath TEXT
          );
        ''');
      },
    );

    // Initialize DatabaseHelper with the test database
    databaseHelper = DatabaseHelper();
  });

  tearDown(() async {
    // Clean up after each test by closing the database
    await db.close();
  });

  group('Database Movie Tests', () {

    test('Remove Watchlist Movie should return the correct value', () async {
      // Insert a movie into the database first
      const movie = MovieTable(
        id: 1,
        title: 'Movie 1',
        overview: 'overview 1',
        posterPath: 'poster 1',
      );

      await databaseHelper.insertWatchlistMovie(movie);

      // Now, remove the movie from the watchlist
      final result = await databaseHelper.removeWatchlistMovie(movie);

      // Assert that 1 row was affected (deleted)
      expect(result, 1);

      // Verify that the movie is actually removed
      final resultDb = await databaseHelper.getMovieById(movie.id);
      expect(resultDb, null);
    });

  });

  group('Database Tv Series Tests', () {
    test('Remove Watchlist Tv Series should return the correct value', () async {
      // Insert a movie into the database first
      const tvSeries = TvSeriesTable(
        id: 1,
        name: 'Tv Series 1',
        overview: 'overview 1',
        posterPath: 'poster 1',
      );

      await databaseHelper.insertWatchlistTvSeries(tvSeries);

      // Now, remove the movie from the watchlist
      final result = await databaseHelper.removeWatchlistTvSeries(tvSeries);

      // Assert that 1 row was affected (deleted)
      expect(result, 1);

      // Verify that the movie is actually removed
      final resultDb = await databaseHelper.getTvSeriesById(tvSeries.id);
      expect(resultDb, null);
    });

  });
}
