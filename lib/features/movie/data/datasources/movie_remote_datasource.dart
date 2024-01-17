import 'dart:convert';

import 'package:flickfinder/core/common/api_config.dart';
import 'package:flickfinder/features/movie/data/models/movie_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';
import '../../domain/entities/movie_entity.dart';

abstract class MovieRemoteDatasource {
  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [ApiException] for all error codes
  Future<List<MovieModel>> getMovies(int page);
  Future<List<MovieModel>> getFilteredMovies(String url, int page);
}

class MovieRemoteDatasourceImpl implements MovieRemoteDatasource {
  final http.Client client;

  MovieRemoteDatasourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getMovies(int page) =>
      getMoviesfromUrl("${ApiConfig.movies}?page=$page");

  @override
  Future<List<MovieModel>> getFilteredMovies(String url, int page) =>
      getMoviesfromUrl("${ApiConfig.movies}?page=$page&$url");

  Future<List<MovieModel>> getMoviesfromUrl(String url) async {
    print(url);
    List<MovieModel> movies = [];
    final response = await client.get(
      Uri.parse(url),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> _responseData = json.decode(response.body);
      final List result = _responseData["results"];
      result.forEach((movie) {
        movies.add(MovieModel.fromJson(movie));
      });
      return movies;
    } else {
      throw ApiException(
          message: "${response.reasonPhrase}", statuscode: response.statusCode);
    }
  }
}
