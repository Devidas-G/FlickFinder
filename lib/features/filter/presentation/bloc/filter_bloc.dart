import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flickfinder/core/utils/enum.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<GetFilterOptions>(_mapEventToState);
  }
  Future<void> _mapEventToState(
    GetFilterOptions event,
    Emitter<FilterState> emit,
  ) async {
    print(event.filterParameters);
    emit(state.copyWith(
        status: FilterStatus.loaded,
        message: "${event.filterParameters.name}"));
  }
}
