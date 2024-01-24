import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/explore/domain/entities/media_entity.dart';
import 'package:flickfinder/features/explore/domain/usecases/getfilteredmovies.dart';
import 'package:flickfinder/features/explore/domain/usecases/getmedia.dart';

import '../../../../core/errors/failure.dart';

part 'movie_event.dart';
part 'movie_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMedia getMedia;
  final GetFilteredMovies getFilteredMovies;
  MovieBloc({
    required this.getMedia,
    required this.getFilteredMovies,
  }) : super(const MovieState()) {
    on<GetMediaEvent>(_mapGetMoviesEventToState);
    on<GetFilteredMoviesEvent>(_mapGetFilteredMoviesEventToState);
  }

  Future<void> _mapGetMoviesEventToState(
    GetMediaEvent event,
    Emitter<MovieState> emit,
  ) async {
    final int newPageKey = event.currentPage + 1;
    if (state.status != MovieStatus.initial) {
      emit(state.copyWith(
        status: MovieStatus.loading,
        movies: [],
      ));
    }
    //if (state.status != MovieStatus.initial) return;

    final result = await getMedia(GetMediaParams(newPageKey, event.mediaType));
    result.fold(
        (failure) => emit(state.copyWith(
              status: MovieStatus.error,
              statusCode: failure.statusCode,
              message: mapFailureToMessage(failure),
            )), (movieslist) {
      //Success
      if (movieslist.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
            status: MovieStatus.loaded,
            movies: movieslist,
            hasReachedMax: false,
            currentPage: newPageKey,
            mediaType: event.mediaType));
      }
    });
  }

  Future<void> _mapGetFilteredMoviesEventToState(
    GetFilteredMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.status == MovieStatus.loading) {
      final result = await getFilteredMovies(
          GetFilteredMoviesParams(event.page, event.url));
      result.fold(
        (failure) => emit(state.copyWith(
          status: MovieStatus.error,
          statusCode: failure.statusCode,
          message: mapFailureToMessage(failure),
        )),
        (movieslist) => emit(state.copyWith(
          status: MovieStatus.loaded,
          movies: List.of(state.movies)..addAll(movieslist),
          hasReachedMax: false,
        )),
      );
    } else {
      final result = await getFilteredMovies(
          GetFilteredMoviesParams(event.page, event.url));
      result.fold(
        (failure) => emit(state.copyWith(
          status: MovieStatus.error,
          statusCode: failure.statusCode,
          message: mapFailureToMessage(failure),
        )),
        (movieslist) => movieslist.isEmpty
            ? emit(state.copyWith(hasReachedMax: true))
            : emit(state.copyWith(
                status: MovieStatus.loaded,
                movies: List.of(state.movies)..addAll(movieslist),
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
