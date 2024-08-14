import 'dart:convert';

import 'package:flickfinder/core/config/api_config.dart';
import 'package:flickfinder/features/media/data/models/movie_model.dart';
import 'package:flickfinder/features/media/data/models/tvshow_model.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';
import '../../../filter/domain/entities/genreentity.dart';

abstract class MediaRemoteDatasource {
  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [ApiException] for all error codes

  Future<List<MovieModel>> getMovies(GetMediaParams params);
  Future<List<TvShowModel>> getTvShows(GetMediaParams params);
}

class MediaRemoteDatasourceImpl implements MediaRemoteDatasource {
  final http.Client client;

  MediaRemoteDatasourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getMovies(GetMediaParams params) =>
      getMoviesFromUrl(getUrlFromParams(
        mediaUrl: ApiConfig.movies,
        category: params.category,
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
  Future<List<TvShowModel>> getTvShows(GetMediaParams params) =>
      getTvShowfromUrl(getUrlFromParams(
        mediaUrl: ApiConfig.tvShows,
        category: params.category,
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

  Future<List<MovieModel>> getMoviesFromUrl(String url) async {
    try {
      // Log the URL for debugging
      debugPrint('Fetching movies from: $url');

      // Perform the HTTP GET request
      final response = await client.get(
        Uri.parse(url),
        headers: ApiConfig.getHeaders(),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the list of movie results
        final List<dynamic> results = responseData["results"] ?? [];

        // Map each result to a MovieModel instance and return the list
        return results.map((movie) => MovieModel.fromJson(movie)).toList();
      } else {
        // Handle HTTP error responses
        throw ApiException(
          message: "Failed to load movies: ${response.reasonPhrase}",
          statuscode: response.statusCode,
        );
      }
    } catch (e) {
      // Catch any other errors that may occur
      throw ApiException(
        message: "An error occurred while fetching movies: $e",
        statuscode: 500,
      );
    }
  }

  Future<List<TvShowModel>> getTvShowfromUrl(String url) async {
    try {
      // Log the URL for debugging
      debugPrint('Fetching movies from: $url');

      // Perform the HTTP GET request
      final response = await client.get(
        Uri.parse(url),
        headers: ApiConfig.getHeaders(),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the list of movie results
        final List<dynamic> results = responseData["results"] ?? [];

        // Map each result to a MovieModel instance and return the list
        return results.map((tvShow) => TvShowModel.fromJson(tvShow)).toList();
      } else {
        // Handle HTTP error responses
        throw ApiException(
          message: "Failed to load movies: ${response.reasonPhrase}",
          statuscode: response.statusCode,
        );
      }
    } catch (e) {
      // Catch any other errors that may occur
      throw ApiException(
        message: "An error occurred while fetching movies: $e",
        statuscode: 500,
      );
    }
  }

  String getUrlFromParams(
      {required String mediaUrl,
      String? category,
      bool? isFiltered,
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
    String categoryPath = "/$category";
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
    // String discover = isFiltered! ? "/discover" : "";
    return "${ApiConfig.apiHost}$mediaUrl$categoryPath$pageUrl$genreUrl$primaryReleaseDateGTEUrl$primaryReleaseDateLTEUrl$voteAverageGTEUrl$languageUrl$certificationCountryUrl$certificationUrl$castIdUrl$regionUrl$yearUrl";
  }

  // String getCategoryPath(Enum? category) {
  //   switch (category) {
  //     case MoviesList.NowPlaying:
  //       return "now_playing";
  //     case MoviesList.TopRated:
  //       return "top_rated";
  //     case MoviesList.Popular:
  //       return "popular";
  //     case MoviesList.Upcoming:
  //       return "upcoming";
  //     case TvList.AiringToday:
  //       return "airing_today";
  //     case TvList.OnAir:
  //       return "on_the_air";
  //     case TvList.Popular:
  //       return "popular";
  //     case TvList.TopRated:
  //       return "top_rated";
  //     default:
  //       return "";
  //   }
  // }
}
