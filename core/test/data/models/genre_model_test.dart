import 'package:core/data/models/genre_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: "Action");
  const tGenre = Genre(id: 1, name: "Action");
  final tGenreJson = {"id": 1, "name": "Action"};

  group('GenreModel', () {
    test('should be a subclass of Genre entity', () async {
      final result = tGenreModel.toEntity();
      expect(result, tGenre);
    });

    test('fromJson should return a valid model', () {
      // act
      final result = GenreModel.fromJson(tGenreJson);

      // assert
      expect(result.id, tGenreModel.id);
      expect(result.name, tGenreModel.name);
    });

    test('toJson should return a valid JSON map', () {
      // act
      final result = tGenreModel.toJson();

      // assert
      expect(result, tGenreJson);
    });
  });
}
