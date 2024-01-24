part of 'filter_bloc.dart';

enum FilterStatus { initial, loading, loaded, error }

final class FilterState extends Equatable {
  const FilterState({
    this.status = FilterStatus.initial,
    this.statusCode = 0,
    this.message = "",
    this.filterParameters = FilterParameters.Genres,
  });
  final FilterStatus status;
  final int statusCode;
  final String message;
  final FilterParameters filterParameters;

  @override
  List<Object> get props => [];

  FilterState copyWith({
    FilterStatus? status,
    int? statusCode,
    String? message,
    FilterParameters? filterParameters,
  }) {
    return FilterState(
      status: status ?? this.status,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      filterParameters: filterParameters ?? this.filterParameters,
    );
  }

  @override
  String toString() {
    return 'FilterState { status: $status, statusCode: $statusCode, message: $message, filterParameters: $filterParameters }';
  }
}
