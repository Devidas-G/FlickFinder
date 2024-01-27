import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';

abstract class FilterRepo {
  ResultFuture<List<FilterEntity>> getFilterOptions(
      FilterParameters filterParameters);
}
