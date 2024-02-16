import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';
import 'package:flickfinder/features/filter/domain/repositories/filterrepo.dart';
import 'package:flickfinder/features/filter/presentation/bloc/filter_bloc.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';

class GetFilterOptions
    implements
        UseCaseWithBloc<List<FilterEntity>, GetFilteredMediaParams,
            FilterBloc> {
  final FilterRepo repository;

  GetFilterOptions(this.repository);

  @override
  ResultFuture<List<FilterEntity>> call(
      GetFilteredMediaParams params, FilterBloc filterBloc) async {
    return await repository.getFilterOptions(params, filterBloc);
  }
}
