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
    on<GetMediaEvent>(_mapGetMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetMediaWithParamsEvent>(_mapGetMediaWithParamsEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetFilterMediaEvent>(_mapGetFilterMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _mapGetMediaEventToState(
    GetMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    if (event.mediaType != state.mediaType) {
      emit(state.copyWith(
          status: MediaStatus.initial,
          media: [],
          hasReachedMax: false,
          currentPage: 0,
          mediaType: event.mediaType));
    }
    if (state.status == MediaStatus.loading) return;
    final int newPageKey = state.currentPage + 1;
    if (state.status != MediaStatus.initial) {
      emit(state.copyWith(
        status: MediaStatus.loading,
        media: state.media,
      ));
    }

    //if (state.status != MovieStatus.initial) return;

    final result = await getMedia(GetMediaParams(newPageKey, event.mediaType));
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
            mediaType: event.mediaType));
      }
    });
  }

  Future<void> _mapGetMediaWithParamsEventToState(
    GetMediaWithParamsEvent event,
    Emitter<MediaState> emit,
  ) async {
    _mapMediaEventToState(event, emit, state.currentPage);
  }

  Future<void> _mapGetFilterMediaEventToState(
      GetFilterMediaEvent event, Emitter<MediaState> emit) async {
    _mapMediaEventToState(event, emit, 0);
  }

  Future<void> _mapMediaEventToState(GetMediaWithParamsEvent event,
      Emitter<MediaState> emit, int pageKey) async {
    if (event.mediaType != state.mediaType) {
      emit(state.copyWith(
          status: MediaStatus.initial,
          media: [],
          hasReachedMax: false,
          currentPage: 0,
          mediaType: event.mediaType));
    }
    if (state.status == MediaStatus.loading) return;
    final int newPageKey = pageKey + 1;
    if (state.status != MediaStatus.initial) {
      emit(state.copyWith(
        status: MediaStatus.loading,
        media: state.media,
      ));
    }
    final result = await getFilteredMedia(GetFilteredMediaParams(
      page: newPageKey,
      mediaType: event.mediaType,
      genre: event.genre,
      primaryReleaseDateGTE: event.primaryReleaseDateGTE,
      primaryReleaseDateLTE: event.primaryReleaseDateLTE,
      voteAverageGTE: event.voteAverageGTE,
      language: event.language,
      certificationCountry: event.certificationCountry,
      certification: event.certification,
      castId: event.castId,
      region: event.region,
      year: event.year,
    ));
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
            mediaType: event.mediaType));
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
