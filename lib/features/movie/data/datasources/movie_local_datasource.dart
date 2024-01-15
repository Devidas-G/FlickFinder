import 'dart:convert';

import 'package:flickfinder/features/movie/data/models/movie_model.dart';

import '../../../../core/errors/exception.dart';
import '../../domain/entities/movie_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MovieLocalDatasource {
  Future<List<MovieModel>> getLastPopularMovies();
  Future<void> cachePopularMovies({required List<MovieModel> movies});
}

const CACHED_MOVIES = "CACHED_MOVIES";

class MovieLocalDatasourceImpl implements MovieLocalDatasource {
  final SharedPreferences sharedPreferences;

  MovieLocalDatasourceImpl({required this.sharedPreferences});
  @override
  Future<List<MovieModel>> getLastPopularMovies() {
    final encodedList = sharedPreferences.getStringList(CACHED_MOVIES);
    List<MovieModel> movies = [];
    if (encodedList != null) {
      for (var movie in encodedList) {
        movies.add(MovieModel.fromJson(json.decode(movie)));
      }
      return Future.value(movies);
    } else {
      throw CacheException("No Movies found in cache");
    }
  }

  @override
  Future<void> cachePopularMovies({required List<MovieModel> movies}) {
    List<String> encodedList = [];
    for (var movie in movies) {
      encodedList.add(json.encode(movie.toJson()));
    }
    return sharedPreferences.setStringList(CACHED_MOVIES, encodedList);
  }
}
