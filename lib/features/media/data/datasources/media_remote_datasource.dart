import 'dart:convert';

import 'package:flickfinder/core/common/api_config.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/media/data/models/movie_model.dart';
import 'package:flickfinder/features/media/data/models/tvshow_model.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';
import '../../../filter/domain/entities/genreentity.dart';
import '../../domain/entities/media_entity.dart';

abstract class MediaRemoteDatasource {
  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [ApiException] for all error codes
  Future<List<MovieModel>> getMovies(int page);
  Future<List<TvShowModel>> getTvShows(int page);
  Future<List<MovieModel>> getFilteredMovies(GetFilteredMediaParams params);
  Future<List<TvShowModel>> getFilteredTvShows(GetFilteredMediaParams params);
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
  Future<List<MovieModel>> getFilteredMovies(GetFilteredMediaParams params) =>
      getMoviefromUrl(getUrlFromParams(
        mediaUrl: ApiConfig.movies,
        genre: params.genre,
        page: params.page,
        primaryReleaseDateGTE: params.primaryReleaseDateGTE,
        primaryReleaseDateLTE: params.primaryReleaseDateLTE,
        voteAverageGTE: params.voteAverageGTE,
        language: params.language,
        certificationCountry: params.certificationCountry,
        certification: params.certification,
        castId: params.castId,
        region: params.region,
        year: params.year,
      ));

  @override
  Future<List<TvShowModel>> getFilteredTvShows(GetFilteredMediaParams params) =>
      getTvShowfromUrl(getUrlFromParams(
        mediaUrl: ApiConfig.tvShows,
        genre: params.genre,
        page: params.page,
        primaryReleaseDateGTE: params.primaryReleaseDateGTE,
        primaryReleaseDateLTE: params.primaryReleaseDateLTE,
        voteAverageGTE: params.voteAverageGTE,
        language: params.language,
        certificationCountry: params.certificationCountry,
        certification: params.certification,
        castId: params.castId,
        region: params.region,
        year: params.year,
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
      List<GenreEntity>? genre,
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
    List<String> genreIds =
        genre == null ? [] : genre.map((genre) => genre.id.toString()).toList();
    String genreUrl = genre == null ? "" : "&with_genres=${genreIds.join(",")}";
    String pageUrl = page == null ? "" : "?page=$page";
    String primaryReleaseDateGTEUrl = primaryReleaseDateGTE == null
        ? ""
        : "&primary_release_date.gte=$primaryReleaseDateGTE";
    String primaryReleaseDateLTEUrl = primaryReleaseDateLTE == null
        ? ""
        : "&primary_release_date.lte=$primaryReleaseDateLTE";
    String voteAverageGTEUrl =
        voteAverageGTE == null ? "" : "&vote_average.gte=$voteAverageGTE";
    String languageUrl =
        language == null ? "" : "&with_original_language=$language";
    String certificationCountryUrl = certificationCountry == null
        ? ""
        : "&certification_country=$certificationCountry";
    String certificationUrl =
        certification == null ? "" : "&certification=$certification";
    String castIdUrl = castId == null ? "" : "&with_cast=$castId";
    String regionUrl = region == null ? "" : "&region=$region";
    String yearUrl = year == null ? "" : "&year=$year";

    return "$mediaUrl$pageUrl$genreUrl$primaryReleaseDateGTEUrl$primaryReleaseDateLTEUrl$voteAverageGTEUrl$languageUrl$certificationCountryUrl$certificationUrl$castIdUrl$regionUrl$yearUrl";
  }
}
