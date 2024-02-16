import 'dart:convert';

import 'package:flickfinder/core/common/api_config.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/filter/data/models/filter_model.dart';
import 'package:flickfinder/features/filter/data/models/genre_model.dart';
import 'package:flickfinder/features/filter/domain/entities/genreentity.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';

abstract class FilterRemoteDatasource {
  Future<List<GenreModel>> getGenre(MediaType mediaType);
}

class FilterRemoteDatasourceImpl implements FilterRemoteDatasource {
  final http.Client client;

  FilterRemoteDatasourceImpl({required this.client});
  @override
  Future<List<FilterModel>> getFilterOptions(
          FilterParameters filterParameters) =>
      getFilterOptionsFromUrl("");

  Future<List<FilterModel>> getFilterOptionsFromUrl(String url) async {
    List<FilterModel> options = [];
    final response = await client.get(
      Uri.parse(url),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> _responseData = json.decode(response.body);
      final List result = _responseData["results"];
      // result.forEach((movie) {
      //   options.add(FilterModel.fromJson(movie));
      // });
      return options;
    } else {
      throw ApiException(
          message: "${response.reasonPhrase}", statuscode: response.statusCode);
    }
  }

  Future<String> _getMediaType(MediaType mediaType) async {
    if (mediaType == MediaType.Movies) {
      return "movie";
    } else {
      return "tv";
    }
  }

  @override
  Future<List<GenreModel>> getGenre(MediaType mediaType) async {
    List<GenreModel> genres = [];
    String mediatype = await _getMediaType(mediaType);
    final response = await client.get(
      Uri.parse("${ApiConfig.genre}/$mediatype/list"),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> _responseData = json.decode(response.body);
      final List result = _responseData["genres"];
      result.forEach((genre) {
        genres.add(GenreModel.fromJson(genre));
      });
      return genres;
    } else {
      throw ApiException(
          message: "${response.reasonPhrase}", statuscode: response.statusCode);
    }
  }
}
