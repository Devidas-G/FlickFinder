import 'dart:convert';

import 'package:flickfinder/core/common/api_config.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/explore/data/models/movie_model.dart';
import 'package:flickfinder/features/explore/data/models/tvshow_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';
import '../../domain/entities/media_entity.dart';

abstract class MediaRemoteDatasource {
  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [ApiException] for all error codes
  Future<List<MovieModel>> getMovies(int page);
  Future<List<TvShowModel>> getTvShows(int page);
  Future<List<MovieModel>> getFilteredMovies(String url, int page);
}

class MediaRemoteDatasourceImpl implements MediaRemoteDatasource {
  final http.Client client;

  MediaRemoteDatasourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getMovies(int page) =>
      getMoviefromUrl("${ApiConfig.movies}?page=$page");
  @override
  Future<List<TvShowModel>> getTvShows(int page) =>
      getTvShowfromUrl("${ApiConfig.tvShows}?page=$page");

  @override
  Future<List<MovieModel>> getFilteredMovies(String url, int page) =>
      getMoviefromUrl("${ApiConfig.movies}?page=$page&$url");

  Future<List<MovieModel>> getMoviefromUrl(String url) async {
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

  Future<List<TvShowModel>> getTvShowfromUrl(String url) async {
    print(url);
    List<TvShowModel> tvShows = [];
    final response = await client.get(
      Uri.parse(url),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> _responseData = json.decode(response.body);
      final List result = _responseData["results"];
      result.forEach((movie) {
        tvShows.add(TvShowModel.fromJson(movie));
      });
      return tvShows;
    } else {
      throw ApiException(
          message: "${response.reasonPhrase}", statuscode: response.statusCode);
    }
  }
}
