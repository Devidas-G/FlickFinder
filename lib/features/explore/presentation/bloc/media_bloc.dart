import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/explore/domain/entities/media_entity.dart';
import 'package:flickfinder/features/explore/domain/usecases/getfilteredmovies.dart';
import 'package:flickfinder/features/explore/domain/usecases/getmedia.dart';
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
  final GetFilteredMovies getFilteredMovies;
  MediaBloc({
    required this.getMedia,
    required this.getFilteredMovies,
  }) : super(const MediaState()) {
    on<GetMediaEvent>(_mapGetMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetFilteredMoviesEvent>(_mapGetFilteredMoviesEventToState);
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
        emit(state.copyWith(hasReachedMax: true));
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

  Future<void> _mapGetFilteredMoviesEventToState(
    GetFilteredMoviesEvent event,
    Emitter<MediaState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.status == MediaStatus.loading) {
      final result = await getFilteredMovies(
          GetFilteredMoviesParams(event.page, event.url));
      result.fold(
        (failure) => emit(state.copyWith(
          status: MediaStatus.error,
          statusCode: failure.statusCode,
          message: mapFailureToMessage(failure),
        )),
        (movieslist) => emit(state.copyWith(
          status: MediaStatus.loaded,
          media: List.of(state.media)..addAll(movieslist),
          hasReachedMax: false,
        )),
      );
    } else {
      final result = await getFilteredMovies(
          GetFilteredMoviesParams(event.page, event.url));
      result.fold(
        (failure) => emit(state.copyWith(
          status: MediaStatus.error,
          statusCode: failure.statusCode,
          message: mapFailureToMessage(failure),
        )),
        (movieslist) => movieslist.isEmpty
            ? emit(state.copyWith(hasReachedMax: true))
            : emit(state.copyWith(
                status: MediaStatus.loaded,
                media: List.of(state.media)..addAll(movieslist),
                hasReachedMax: false,
              )),
      );
    }
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
