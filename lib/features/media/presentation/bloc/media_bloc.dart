import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/errors/failure.dart';

part 'media_event.dart';
part 'media_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final GetMedia getMedia;
  MediaBloc({
    required this.getMedia,
  }) : super(const MediaState()) {
    on<GetMediaWithParamsEvent>(_mapGetMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetMoreMediaEvent>(_mapGetMoreMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _mapGetMoreMediaEventToState(
    GetMoreMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    if (state.status == MediaStatus.loadingMore) return;
    final int newPageKey = state.currentPage + 1;
    emit(state.copyWith(
      status: MediaStatus.loadingMore,
    ));

    final result =
        await getMedia(state.getFilteredMediaParams.copyWith(page: newPageKey));
    result.fold(
        (failure) => emit(state.copyWith(
              status: MediaStatus.error,
              statusCode: failure.statusCode,
              message: mapFailureToMessage(failure),
            )), (medialist) {
      //Success
      if (medialist.isEmpty) {
        emit(state.copyWith(status: MediaStatus.loaded, hasReachedMax: true));
      } else {
        emit(state.copyWith(
            status: MediaStatus.loaded,
            media: List.of(state.media)..addAll(medialist),
            hasReachedMax: false,
            currentPage: newPageKey,
            getFilteredMediaParams:
                state.getFilteredMediaParams.copyWith(page: newPageKey)));
      }
    });
  }

  Future<void> _mapGetMediaEventToState(
      GetMediaWithParamsEvent event, Emitter<MediaState> emit) async {
    emit(state.copyWith(
      status: MediaStatus.initial,
      media: [],
    ));
    final result =
        await getMedia(event.getFilteredMediaParams.copyWith(page: 1));
    result.fold(
        (failure) => emit(state.copyWith(
              status: MediaStatus.error,
              statusCode: failure.statusCode,
              message: mapFailureToMessage(failure),
            )), (medialist) {
      //Success
      if (medialist.isEmpty) {
        emit(state.copyWith(status: MediaStatus.loaded, hasReachedMax: true));
      } else {
        emit(state.copyWith(
            status: MediaStatus.loaded,
            media: List.of(state.media)..addAll(medialist),
            hasReachedMax: false,
            currentPage: 1,
            mediaType: event.getFilteredMediaParams.mediaType,
            getFilteredMediaParams:
                event.getFilteredMediaParams.copyWith(page: 1)));
      }
    });
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
