// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'filter_bloc.dart';

sealed class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class GetFilterOption extends FilterEvent {
  final FilterBloc filterBloc;
  const GetFilterOption(this.filterBloc);
  @override
  List<Object> get props => [filterBloc];
}

class UpdateFilterparmas extends FilterEvent {
  final GetMediaParams newFilterParams;

  const UpdateFilterparmas({required this.newFilterParams});
  @override
  List<Object> get props => [newFilterParams];
}

class UpdateMediaType extends FilterEvent {
  final MediaType mediaType;

  const UpdateMediaType({required this.mediaType});
  @override
  List<Object> get props => [mediaType];
}
