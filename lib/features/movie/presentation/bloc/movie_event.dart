part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class GetMoviesEvent extends MovieEvent {
  final int page;
  const GetMoviesEvent(this.page);

  @override
  List<Object> get props => [page];
}

class GetFilteredMoviesEvent extends MovieEvent {
  final int page;
  final String url;
  const GetFilteredMoviesEvent(this.page, this.url);
  @override
  List<Object> get props => [page, url];
}
