part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class GetMoviesEvent extends MovieEvent {
  final int genreId;
  final int page;
  const GetMoviesEvent(this.genreId, this.page);

  @override
  List<Object> get props => [genreId];
}
