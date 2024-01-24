part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class GetMediaEvent extends MovieEvent {
  final int currentPage;
  final MediaType mediaType;
  const GetMediaEvent(this.currentPage, this.mediaType);

  @override
  List<Object> get props => [currentPage, mediaType];
}

class GetFilteredMoviesEvent extends MovieEvent {
  final int page;
  final String url;
  const GetFilteredMoviesEvent(this.page, this.url);
  @override
  List<Object> get props => [page, url];
}
