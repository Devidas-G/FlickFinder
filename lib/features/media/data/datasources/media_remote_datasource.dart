import 'dart:convert';

import 'package:flickfinder/core/common/api_config.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/media/data/models/movie_model.dart';
import 'package:flickfinder/features/media/data/models/tvshow_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';
import '../../domain/entities/media_entity.dart';

abstract class MediaRemoteDatasource {
  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [ApiException] for all error codes
  Future<List<MovieModel>> getMovies(int page);
  Future<List<TvShowModel>> getTvShows(int page);
  Future<List<MovieModel>> getFilteredMovies(
      {int genre,
      int page,
      String primaryReleaseDateGTE,
      String primaryReleaseDateLTE,
      double voteAverageGTE,
      String language,
      String certificationCountry,
      String certification,
      int castId,
      String region,
      int year});
  Future<List<TvShowModel>> getFilteredTvShows(
      {int genre,
      int page,
      String primaryReleaseDateGTE,
      String primaryReleaseDateLTE,
      double voteAverageGTE,
      String language,
      String certificationCountry,
      String certification,
      int castId,
      String region,
      int year});
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
  Future<List<MovieModel>> getFilteredMovies(
          {int? genre,
          int? page,
          String? primaryReleaseDateGTE,
          String? primaryReleaseDateLTE,
          double? voteAverageGTE,
          String? language,
          String? certificationCountry,
          String? certification,
          int? castId,
          String? region,
          int? year}) =>
      getMoviefromUrl(getUrlFromParams(
        mediaUrl: ApiConfig.movies,
        genre: genre,
        page: page,
        primaryReleaseDateGTE: primaryReleaseDateGTE,
        primaryReleaseDateLTE: primaryReleaseDateLTE,
        voteAverageGTE: voteAverageGTE,
        language: language,
        certificationCountry: certificationCountry,
        certification: certification,
        castId: castId,
        region: region,
        year: year,
      ));

  @override
  Future<List<TvShowModel>> getFilteredTvShows(
          {int? genre,
          int? page,
          String? primaryReleaseDateGTE,
          String? primaryReleaseDateLTE,
          double? voteAverageGTE,
          String? language,
          String? certificationCountry,
          String? certification,
          int? castId,
          String? region,
          int? year}) =>
      getTvShowfromUrl(getUrlFromParams(
        mediaUrl: ApiConfig.tvShows,
        genre: genre,
        page: page,
        primaryReleaseDateGTE: primaryReleaseDateGTE,
        primaryReleaseDateLTE: primaryReleaseDateLTE,
        voteAverageGTE: voteAverageGTE,
        language: language,
        certificationCountry: certificationCountry,
        certification: certification,
        castId: castId,
        region: region,
        year: year,
      ));

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

  String getUrlFromParams(
      {required String mediaUrl,
      int? genre,
      int? page,
      String? primaryReleaseDateGTE,
      String? primaryReleaseDateLTE,
      double? voteAverageGTE,
      String? language,
      String? certificationCountry,
      String? certification,
      int? castId,
      String? region,
      int? year}) {
    return "$mediaUrl?page=$page&with_genres=$genre&primary_release_date.gte=$primaryReleaseDateGTE&primary_release_date.lte=$primaryReleaseDateLTE&vote_average.gte=$voteAverageGTE&with_original_language=$language&certification_country=$certificationCountry&certification=$certification&with_cast=$castId&region=$region&year=$year";
  }
}
