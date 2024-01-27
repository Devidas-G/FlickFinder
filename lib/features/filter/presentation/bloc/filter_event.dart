// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_bloc.dart';

sealed class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class GetFilterOptions extends FilterEvent {
  FilterParameters filterParameters;
  GetFilterOptions(this.filterParameters);
  @override
  List<Object> get props => [filterParameters];
}
