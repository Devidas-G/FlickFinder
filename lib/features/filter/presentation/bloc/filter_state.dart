part of 'filter_bloc.dart';

enum FilterStatus { initial, loading, loaded, error }

final class FilterState extends Equatable {
  const FilterState({
    this.status = FilterStatus.initial,
    this.statusCode = 0,
    this.message = "",
    this.filterList = const [],
    this.newFilterParams =
        const GetMediaParams(mediaType: MediaType.Movies, category: ''),
    this.tempFilterParams =
        const GetMediaParams(mediaType: MediaType.Movies, category: ''),
    this.mediaType = MediaType.Movies,
  });
  final FilterStatus status;
  final int statusCode;
  final String message;
  final List<FilterEntity> filterList;
  final GetMediaParams newFilterParams;
  final GetMediaParams tempFilterParams;
  final MediaType mediaType;

  @override
  List<Object> get props => [
        status,
        statusCode,
        message,
        filterList,
        newFilterParams,
        tempFilterParams,
        mediaType
      ];

  FilterState copyWith({
    FilterStatus? status,
    int? statusCode,
    String? message,
    List<FilterEntity>? filterList,
    GetMediaParams? newFilterParams,
    GetMediaParams? tempFilterParams,
    MediaType? mediaType,
  }) {
    return FilterState(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      filterList: filterList ?? this.filterList,
      newFilterParams: newFilterParams ?? this.newFilterParams,
      tempFilterParams: tempFilterParams ?? this.tempFilterParams,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  @override
  String toString() {
    return 'FilterState { status: $status, statusCode: $statusCode, message: $message, filterList: $filterList, newFilterParams: $newFilterParams,tempFilterParams: $tempFilterParams, MediaType: $mediaType,}';
  }
}
