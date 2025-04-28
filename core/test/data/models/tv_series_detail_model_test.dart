import 'dart:convert';

import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/season_model.dart';
import 'package:core/data/models/tv_series_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main(){

  const tTvDetailResponseModel = TvSeriesDetailResponse(
      backdropPath: "/gc8PfyTqzqltKPW3X0cIVUGmagz.jpg",
      firstAirDate: "2008-01-20",
      genres: [
        GenreModel(id: 18, name: "Drama"),
        GenreModel(id: 80, name: "Crime")
      ],
      homepage: "https://www.sonypictures.com/tv/breakingbad",
      id: 1396,
      inProduction: false,
      languages: ["en","de","es"],
      lastAirDate: "2013-09-29",
      name:  "Breaking Bad",
      numberOfEpisodes: 62,
      numberOfSeasons: 5,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Breaking Bad",
      overview: "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
      popularity: 571.19,
      posterPath: "/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg",
      seasons: [
        SeasonModel(
            airDate: "2009-02-17",
            episodeCount: 9,
            id: 3577,
            name: "Specials",
            overview: "",
            posterPath: "/40dT79mDEZwXkQiZNBgSaydQFDP.jpg",
            seasonNumber: 0
        )
      ],
      status: "Ended",
      tagline: "Change the equation.",
      type: "Scripted",
      voteAverage: 8.9,
      voteCount: 14496
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {

      final Map<String, dynamic> jsonMap =
      json.decode(readJson('dummy_data/tv_series/tv_series_detail.json'));
      // act
      final result = TvSeriesDetailResponse.fromJson(jsonMap);

      expect(result, tTvDetailResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange
      final result = tTvDetailResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "backdrop_path": "/gc8PfyTqzqltKPW3X0cIVUGmagz.jpg",
        "first_air_date": "2008-01-20",
        "genres": [
          {
            "id": 18,
            "name": "Drama"
          },
          {
            "id": 80,
            "name": "Crime"
          }
        ],
        "homepage": "https://www.sonypictures.com/tv/breakingbad",
        "id": 1396,
        "in_production": false,
        "languages": [
          "en",
          "de",
          "es"
        ],
        "last_air_date": "2013-09-29",
        "name": "Breaking Bad",
        "number_of_episodes": 62,
        "number_of_seasons": 5,
        "origin_country": [
          "US"
        ],
        "original_language": "en",
        "original_name": "Breaking Bad",
        "overview": "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
        "popularity": 571.19,
        "poster_path": "/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg",
        "seasons": [
          {
            "air_date": "2009-02-17",
            "episode_count": 9,
            "id": 3577,
            "name": "Specials",
            "overview": "",
            "poster_path": "/40dT79mDEZwXkQiZNBgSaydQFDP.jpg",
            "season_number": 0,
          }
        ],
        "status": "Ended",
        "tagline": "Change the equation.",
        "type": "Scripted",
        "vote_average": 8.9,
        "vote_count": 14496
      };

      expect(result, expectedJsonMap);
    });
  });
}