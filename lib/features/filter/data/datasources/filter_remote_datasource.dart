import 'dart:convert';

import 'package:flickfinder/core/common/api_config.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/filter/data/models/filter_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exception.dart';

abstract class FilterRemoteDatasource {
  Future<List<FilterModel>> getFilterOptions(FilterParameters filterParameters);
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
      result.forEach((movie) {
        options.add(FilterModel.fromJson(movie));
      });
      return options;
    } else {
      throw ApiException(
          message: "${response.reasonPhrase}", statuscode: response.statusCode);
    }
  }
}
