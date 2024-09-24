import 'dart:convert';
import 'dart:io';

import 'package:flickfinder/core/config/api_config.dart';
import 'package:flickfinder/features/media/data/models/movie_model.dart';
import 'package:flickfinder/features/media/data/models/trending_model.dart';
import 'package:flickfinder/features/media/data/models/tvshow_model.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/usecases/getmedia.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';

abstract class MediaRemoteDatasource {
  /// Calls the https://api.themoviedb.org/3/movie/popular endpoint.
  ///
  /// Throws a [ApiException] for all error codes

  Future<List<MovieModel>> getMovies(GetMediaParams params);
  Future<List<TvShowModel>> getTvShows(GetMediaParams params);
  Future<List<TrendingModel>> getTrending();
}

class MediaRemoteDatasourceImpl implements MediaRemoteDatasource {
  MediaRemoteDatasourceImpl();

  @override
  Future<List<MovieModel>> getMovies(GetMediaParams params) =>
      getMoviesFromUrl(getUrlFromParams(
        mediaUrl: ApiConfig.movies,
        category: params.sortType,
        page: params.page,
        year: params.year,
      ));

  @override
  Future<List<TvShowModel>> getTvShows(GetMediaParams params) =>
      getTvShowfromUrl(getUrlFromParams(
        mediaUrl: ApiConfig.tvShows,
        category: params.sortType,
        page: params.page,
        year: params.year,
      ));

  Future<List<MovieModel>> getMoviesFromUrl(String url) async {
    try {
      // Log the URL for debugging

      // Perform the HTTP GET request
      final response = await http.get(
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
        throw HttpException('${response}');
      }
    } on SocketException catch (e) {
      throw ApiException(
        message: e.message,
        statuscode: e.osError!.errorCode,
      );
    } on HttpException catch (e) {
      throw ApiException(
        message: e.message,
      );
    } on FormatException catch (e) {
      throw ApiException(
        message: e.message,
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        message: e.message,
      );
    } catch (e) {
      // Catch any other errors that may occur
      throw ApiException(
        message: "Unknow error occurred while fetching movies: $e",
        statuscode: 500,
      );
    }
  }

  Future<List<TvShowModel>> getTvShowfromUrl(String url) async {
    try {
      // Log the URL for debugging

      // Perform the HTTP GET request
      final response = await http.get(
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
        throw HttpException('${response}');
      }
    } on SocketException catch (e) {
      throw ApiException(
        message: e.message,
        statuscode: e.osError!.errorCode,
      );
    } on HttpException catch (e) {
      throw ApiException(
        message: e.message,
      );
    } on FormatException catch (e) {
      throw ApiException(
        message: e.message,
      );
    } on http.ClientException catch (e) {
      throw ApiException(
        message: e.message,
      );
    } catch (e) {
      // Catch any other errors that may occur
      throw ApiException(
        message: "Unknow error occurred while fetching movies: $e",
        statuscode: 500,
      );
    }
  }

  String getUrlFromParams(
      {required String mediaUrl,
      String? category,
      bool? isFiltered,
      int? page,
      int? year}) {
    String categoryPath = "/$category";
    String pageUrl = page == null ? "" : "?page=$page";
    String yearUrl = year == null ? "" : "&year=$year";
    // String discover = isFiltered! ? "/discover" : "";
    return "${ApiConfig.apiHost}$mediaUrl$categoryPath$pageUrl$yearUrl";
  }

  @override
  Future<List<TrendingModel>> getTrending() async {
    String url = 'https://api.themoviedb.org/3/trending/all/day?language=en-US';
    try {
      // Log the URL for debugging

      // Perform the HTTP GET request
      final response = await http.get(
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
        return results
            .map((trending) => TrendingModel.fromJson(trending))
            .toList();
      } else {
        // Handle HTTP error responses
        throw ApiException(
          message: "Failed to load trending: ${response.reasonPhrase}",
          statuscode: response.statusCode,
        );
      }
    } catch (e) {
      // Catch any other errors that may occur
      throw ApiException(
        message: "An error occurred while fetching trending: $e",
        statuscode: 500,
      );
    }
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
