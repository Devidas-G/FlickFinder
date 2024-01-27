import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/enum.dart';
import '../models/filter_model.dart';

abstract class FilterLocalDatasource {
  Future<List<FilterModel>> getFilterOptions(FilterParameters filterParameters);
  Future<void> cacheFilterOptions({required List<FilterModel> options});
}

class FilterLocalDatasourceImpl implements FilterLocalDatasource {
  final SharedPreferences sharedPreferences;

  FilterLocalDatasourceImpl({required this.sharedPreferences});
  @override
  Future<void> cacheFilterOptions({required List<FilterModel> options}) {
    // TODO: implement cacheFilterOptions
    throw UnimplementedError();
  }

  @override
  Future<List<FilterModel>> getFilterOptions(
      FilterParameters filterParameters) {
    // TODO: implement getFilterOptions
    throw UnimplementedError();
  }
}
