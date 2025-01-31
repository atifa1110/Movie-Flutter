import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=3947a81622a4595a2456add3bddd2ef3';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Tv Series', () {
    final testTvList = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series/now_playing.json')))
        .tvSeriesList;

    test('should return list of Tv Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_series/now_playing.json'), 200));
          // act
          final result = await dataSource.getNowPlayingTvSeries();
          // assert
          expect(result, equals(testTvList));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getNowPlayingTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Popular Tv Series', () {
    final testTvList = TvSeriesResponse.fromJson(json.decode(readJson('dummy_data/tv_series/popular.json')))
            .tvSeriesList;

    test('should return list of movies when response is success (200)', () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_series/popular.json'), 200));
          // act
          final result = await dataSource.getPopularTvSeries();
          // assert
          expect(result, testTvList);
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getPopularTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get Top Rated Tv Series', () {
    final testTvList = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/top_rated.json')))
        .tvSeriesList;

    test('should return list of movies when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_series/top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTvSeries();
      // assert
      expect(result, testTvList);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTopRatedTvSeries();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv detail', () {
    final testId = 1;
    final testTvDetail = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series/movie_detail.json')));

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$testId?$API_KEY')))
          .thenAnswer((_) async =>
          http.Response(readJson('dummy_data/tv_series/tv_series_detail.json'), 200));
      // act
      final result = await dataSource.getTvSeriesDetail(testId);
      // assert
      expect(result, equals(testTvDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$testId?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTvSeriesDetail(testId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('get tv recommendations', () {
    final testTvList = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series/tv_series_recommendations.json'))).tvSeriesList;
    final testId = 1;

    test('should return list of Movie Model when the response code is 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$testId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_series/tv_series_recommendations.json'), 200));
          // act
          final result = await dataSource.getTvSeriesRecommendations(testId);
          // assert
          expect(result, equals(testTvList));
        });

    test('should throw Server Exception when the response code is 404 or other',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$testId/recommendations?$API_KEY')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.getTvSeriesRecommendations(testId);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });

  group('search tv', () {
    final testSearchResult = TvSeriesResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series/search_tv_series.json')))
        .tvSeriesList;
    final testQuery = '';

    test('should return list of tvs when response code is 200', () async {
      // arrange
      when(mockHttpClient
          .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$testQuery')))
          .thenAnswer((_) async => http.Response(
          readJson('dummy_data/tv_series/search_tv_series.json'), 200));
      // act
      final result = await dataSource.searchTvSeries(testQuery);
      // assert
      expect(result, testSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
            () async {
          // arrange
          when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$testQuery')))
              .thenAnswer((_) async => http.Response('Not Found', 404));
          // act
          final call = dataSource.searchTvSeries(testQuery);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        });
  });
}