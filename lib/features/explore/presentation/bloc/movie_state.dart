part of 'movie_bloc.dart';

enum MovieStatus { initial, loading, loaded, error }

final class MovieState extends Equatable {
  const MovieState(
      {this.status = MovieStatus.initial,
      this.movies = const <MediaEntity>[],
      this.hasReachedMax = false,
      this.statusCode = 0,
      this.message = "",
      this.currentPage = 0,
      this.mediaType = MediaType.Movies});
  final MovieStatus status;
  final List<MediaEntity> movies;
  final bool hasReachedMax;
  final int statusCode;
  final int currentPage;
  final String message;
  final MediaType mediaType;

  @override
  List<Object> get props => [
        status,
        movies,
        hasReachedMax,
        statusCode,
        message,
        currentPage,
        mediaType
      ];

  MovieState copyWith({
    MovieStatus? status,
    List<MediaEntity>? movies,
    bool? hasReachedMax,
    int? statusCode,
    String? message,
    int? currentPage,
    MediaType? mediaType,
  }) {
    return MovieState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      currentPage: currentPage ?? this.currentPage,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, movies: ${movies.length}, statusCode: $statusCode, message: $message, currentPage: $currentPage, MediaType: $mediaType}''';
  }
}
