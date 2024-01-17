import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flickfinder/features/movie/domain/entities/movie_entity.dart';
import 'package:flickfinder/features/movie/domain/usecases/getfilteredmovies.dart';
import 'package:flickfinder/features/movie/domain/usecases/getmovies.dart';
import 'package:flickfinder/features/movie/providers/moviesprovider.dart';

import '../../../../core/errors/failure.dart';

part 'movie_event.dart';
part 'movie_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovies getMovies;
  final GetFilteredMovies getFilteredMovies;
  final int numberOfPostsPerRequest = 5;
  MovieBloc({
    required this.getMovies,
    required this.getFilteredMovies,
  }) : super(MovieInitial()) {
    on<GetMoviesEvent>(_mapGetMoviesEventToState);
    on<GetFilteredMoviesEvent>(_mapGetFilteredMoviesEventToState);
  }

  Future<void> _mapGetMoviesEventToState(
    GetMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    final result = await getMovies(GetMoviesParams(event.page));

    result.fold(
      (failure) => emit(MovieError(failure.statusCode,
          message: mapFailureToMessage(failure))),
      (movieslist) {
        emit(MovieLoaded(movies: movieslist));
      },
    );
  }

  Future<void> _mapGetFilteredMoviesEventToState(
    GetFilteredMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    final result =
        await getFilteredMovies(GetFilteredMoviesParams(event.page, event.url));
    result.fold(
      (failure) => emit(MovieError(failure.statusCode,
          message: mapFailureToMessage(failure))),
      (movieslist) {
        emit(MovieLoaded(movies: movieslist));
      },
    );
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
