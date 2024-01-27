import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';
import 'package:flickfinder/features/filter/domain/repositories/filterrepo.dart';

class GetFilterOptions
    implements UseCase<List<FilterEntity>, GetFilterOptionsParams> {
  final FilterRepo repository;

  GetFilterOptions(this.repository);

  @override
  ResultFuture<List<FilterEntity>> call(GetFilterOptionsParams params) async {
    return await repository.getFilterOptions(params.filterParameters);
  }
}

class GetFilterOptionsParams {
  final FilterParameters filterParameters;

  GetFilterOptionsParams(this.filterParameters);
}
