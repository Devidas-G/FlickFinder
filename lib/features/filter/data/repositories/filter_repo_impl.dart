import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/filter/data/datasources/filter_local_datasource.dart';
import 'package:flickfinder/features/filter/data/datasources/filter_remote_datasource.dart';
import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';
import 'package:flickfinder/features/filter/domain/repositories/filterrepo.dart';

import '../../../../core/platform/network_info.dart';

class FilterRepoImpl implements FilterRepo {
  final FilterLocalDatasource localDatasource;
  final FilterRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  FilterRepoImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});
  @override
  ResultFuture<List<FilterEntity>> getFilterOptions(
      FilterParameters filterParameters) {
    // TODO: implement getFilterOptions
    throw UnimplementedError();
  }
}
