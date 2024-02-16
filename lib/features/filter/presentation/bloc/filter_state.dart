part of 'filter_bloc.dart';

enum FilterStatus { initial, loading, loaded, error }

final class FilterState extends Equatable {
  const FilterState({
    this.status = FilterStatus.initial,
    this.statusCode = 0,
    this.message = "",
    this.filterList = const [],
    this.newFilterParams = const GetFilteredMediaParams(),
    this.mediaType = MediaType.Movies,
  });
  final FilterStatus status;
  final int statusCode;
  final String message;
  final List<FilterEntity> filterList;
  final GetFilteredMediaParams newFilterParams;
  final MediaType mediaType;

  @override
  List<Object> get props =>
      [status, statusCode, message, filterList, newFilterParams, mediaType];

  FilterState copyWith({
    FilterStatus? status,
    int? statusCode,
    String? message,
    List<FilterEntity>? filterList,
    GetFilteredMediaParams? newFilterParams,
    MediaType? mediaType,
  }) {
    return FilterState(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      filterList: filterList ?? this.filterList,
      newFilterParams: newFilterParams ?? this.newFilterParams,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  @override
  String toString() {
    return 'FilterState { status: $status, statusCode: $statusCode, message: $message, filterList: $filterList, newFilterParams: $newFilterParams, MediaType: $mediaType,}';
  }
}
