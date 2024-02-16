import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';

import '../../../media/domain/usecases/getfilteredmedia.dart';
import '../../presentation/bloc/filter_bloc.dart';

abstract class FilterRepo {
  ResultFuture<List<FilterEntity>> getFilterOptions(
      GetFilteredMediaParams params, FilterBloc filterBloc);
}
