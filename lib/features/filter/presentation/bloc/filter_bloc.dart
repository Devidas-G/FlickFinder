import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/usecases/getfilteroptions.dart';

part 'filter_event.dart';
part 'filter_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final GetFilterOptions getFilterOptions;
  FilterBloc({required this.getFilterOptions}) : super(const FilterState()) {
    on<GetFilterOption>(_mapEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<UpdateFilterparmas>(_mapUpdateEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<UpdateMediaType>(_mapUpdateMediaTypeEventToState,
        transformer: throttleDroppable(throttleDuration));
  }
  Future<void> _mapEventToState(
    GetFilterOption event,
    Emitter<FilterState> emit,
  ) async {
    emit(state.copyWith(status: FilterStatus.loading, message: ""));
    final result =
        await getFilterOptions(event.getFilteredMediaParams, event.filterBloc);
    result.fold(
        (failure) => emit(state.copyWith(
              status: FilterStatus.error,
              statusCode: failure.statusCode,
              message: mapFailureToMessage(failure),
            )), (filterList) {
      //Success
      if (filterList.isEmpty) {
        emit(state.copyWith(status: FilterStatus.loaded));
      } else {
        emit(state.copyWith(
          status: FilterStatus.loaded,
          filterList: filterList,
        ));
      }
    });
  }

  Future<void> _mapUpdateEventToState(
    UpdateFilterparmas event,
    Emitter<FilterState> emit,
  ) async {
    print("update params: ${event.newFilterParams}");
    emit(state.copyWith(newFilterParams: event.newFilterParams));
  }

  Future<void> _mapUpdateMediaTypeEventToState(
    UpdateMediaType event,
    Emitter<FilterState> emit,
  ) async {
    emit(state.copyWith(mediaType: event.mediaType));
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ApiFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case NetworkFailure:
        return "No Internet connection";
      default:
        return 'Unexpected error';
    }
  }
}
