

import 'package:core/data/models/season_model.dart';
import 'package:core/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: "2009-02-17",
    episodeCount: 9,
    id: 3577,
    name: "Specials",
    overview: "",
    posterPath: "/40dT79mDEZwXkQiZNBgSaydQFDP.jpg",
    seasonNumber: 0,
  );

  final tSeasonJson = {
    "air_date": "2009-02-17",
    "episode_count": 9,
    "id": 3577,
    "name": "Specials",
    "overview": "",
    "poster_path": "/40dT79mDEZwXkQiZNBgSaydQFDP.jpg",
    "season_number": 0,
  };
  const tSeason= Season(airDate: "2009-02-17",
    episodeCount: 9,
    id: 3577,
    name: "Specials",
    overview: "",
    posterPath: "/40dT79mDEZwXkQiZNBgSaydQFDP.jpg",
    seasonNumber: 0);

  group('SeasonModel', () {
    test('should be a subclass of Season entity', () async {
      final result = tSeasonModel.toEntity();
      expect(result, tSeason);
    });

    test('fromJson should return a valid model', () {
      // act
      final result = SeasonModel.fromJson(tSeasonJson);
      // assert
      expect(result, equals(tSeasonModel));
    });

    test('toJson should return a valid JSON map', () {
      // act
      final result = tSeasonModel.toJson();
      // assert
      expect(result, tSeasonJson);
    });
  });
}
