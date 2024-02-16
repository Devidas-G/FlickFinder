import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:flickfinder/features/media/domain/usecases/getmedia.dart';
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
  final GetFilteredMedia getFilteredMedia;
  MediaBloc({
    required this.getMedia,
    required this.getFilteredMedia,
  }) : super(const MediaState()) {
    on<GetMediaWithParamsEvent>(_mapGetFilterMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetMoreMediaEvent>(_mapGetMoreMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _mapGetMoreMediaEventToState(
    GetMoreMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    if (state.status == MediaStatus.loading) return;
    final int newPageKey = state.currentPage + 1;
    if (state.status != MediaStatus.initial) {
      emit(state.copyWith(
        status: MediaStatus.loading,
        media: state.media,
      ));
    }

    final result = await getFilteredMedia(
        state.getFilteredMediaParams.copyWith(page: newPageKey));
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

  Future<void> _mapGetFilterMediaEventToState(
      GetMediaWithParamsEvent event, Emitter<MediaState> emit) async {
    if (state.status == MediaStatus.loading) return;
    emit(state.copyWith(
      status: MediaStatus.initial,
      media: [],
    ));
    emit(state.copyWith(
      status: MediaStatus.loading,
      media: state.media,
    ));
    final result =
        await getFilteredMedia(event.getFilteredMediaParams.copyWith(page: 1));
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
        print(event.getFilteredMediaParams.toString());
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
