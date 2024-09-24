import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/presentation/bloc/states/trending_media.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/usecases/usecase.dart';
import 'states/main_media.dart';

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
  final GetTrending getTrending;
  MediaBloc({
    required this.getMedia,
    required this.getTrending,
  }) : super(const MediaState()) {
    on<GetInitialMediaEvent>(_mapGetInitialMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetMoreMediaEvent>(_mapGetMoreMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
    on<GetTrendingMediaEvent>(_mapGetTrendingMediaEventToState,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _mapGetTrendingMediaEventToState(
    GetTrendingMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    // final result = await getTrending();
    // result.fold(
    //     (failure) => emit(state.copyWith(
    //           status: MediaStatus.error,
    //           statusCode: failure.statusCode,
    //           message: mapFailureToMessage(failure),
    //         )), (medialist) {
    //   //Success
    //   if (medialist.isEmpty) {
    //     emit(state.copyWith(status: MediaStatus.loaded));
    //   } else {
    //     final trending = <String, List<MediaEntity>>{
    //       'trending': List.of(state.media)..addAll(medialist)
    //     };
    //     var sub = state.subMedia;
    //     sub.addEntries(trending.entries);
    //     print(sub);
    //     emit(state.copyWith(
    //       subMedia: sub,
    //     ));
    //   }
    // });
  }

  Future<void> _mapGetInitialMediaEventToState(
      GetInitialMediaEvent event, Emitter<MediaState> emit) async {
    int page = 1;
    var mediaType = event.getMediaParams.mediaType;
    emit(state.copyWith(
        mainMediaState: MediaLoading(page, mediaType), mainMedia: []));
    final result = await getMedia(event.getMediaParams.copyWith(page: page));
    result.fold(
        (failure) => emit(state.copyWith(
              mainMediaState: MediaError(
                  failure.message, page, mediaType, failure.statusCode),
            )), (medialist) {
      //Success
      emit(state.copyWith(
          mainMediaState: MediaLoaded(false, page, mediaType),
          mainMedia: medialist,
          getFilteredMediaParams: event.getMediaParams.copyWith(page: page)));
    });
  }

  Future<void> _mapGetMoreMediaEventToState(
    GetMoreMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    final int newPageKey = (state.mainMediaState as MediaLoaded).page + 1;
    var mediaType = state.getMediaParams.mediaType;
    emit(state.copyWith(mainMediaState: MediaLoading(newPageKey, mediaType)));

    final result =
        await getMedia(state.getMediaParams.copyWith(page: newPageKey));
    result.fold(
        (failure) => emit(state.copyWith(
              mainMediaState: MediaError(
                  failure.message, newPageKey, mediaType, failure.statusCode),
            )), (medialist) {
      //Success
      emit(state.copyWith(
          mainMediaState: MediaLoaded(false, newPageKey, mediaType),
          mainMedia: state.mainMedia..addAll(medialist),
          getFilteredMediaParams:
              state.getMediaParams.copyWith(page: newPageKey)));
    });
  }
}
