import 'dart:convert';

import 'package:flickfinder/features/movie/data/models/movie_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const movieModel = MovieModel(
      adult: false,
      backdropPath: "/xgGGinKRL8xeRkaAR9RMbtyk60y.jpg",
      genreIds: [16, 10751, 10402, 14, 35],
      id: 901362,
      originalLanguage: "en",
      originalTitle: "Trolls Band Together",
      overview:
          "When Branch’s brother, Floyd, is kidnapped for his musical talents by a pair of nefarious pop-star villains, Branch and Poppy embark on a harrowing and emotional journey to reunite the other brothers and rescue Floyd from a fate even worse than pop-culture obscurity.",
      popularity: 2553.085,
      posterPath: "/bkpPTZUdq31UGDovmszsg2CchiI.jpg",
      releaseDate: "2023-10-12",
      title: "Trolls Band Together",
      video: false,
      voteAverage: 7.25,
      voteCount: 160);
  group("from json", () {
    test('should return a valid model when json is a integer', () async {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('movie.json'));
      //act
      final result = MovieModel.fromJson(jsonMap);
      //assert
      expect(result, equals(movieModel));
    });
  });
}
