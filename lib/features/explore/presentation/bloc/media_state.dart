part of 'media_bloc.dart';

enum MediaStatus { initial, loading, loaded, error }

final class MediaState extends Equatable {
  const MediaState(
      {this.status = MediaStatus.initial,
      this.media = const <MediaEntity>[],
      this.hasReachedMax = false,
      this.statusCode = 0,
      this.message = "",
      this.currentPage = 0,
      this.mediaType = MediaType.Movies});
  final MediaStatus status;
  final List<MediaEntity> media;
  final bool hasReachedMax;
  final int statusCode;
  final int currentPage;
  final String message;
  final MediaType mediaType;

  @override
  List<Object> get props => [
        status,
        media,
        hasReachedMax,
        statusCode,
        message,
        currentPage,
        mediaType
      ];

  MediaState copyWith({
    MediaStatus? status,
    List<MediaEntity>? media,
    bool? hasReachedMax,
    int? statusCode,
    String? message,
    int? currentPage,
    MediaType? mediaType,
  }) {
    return MediaState(
      status: status ?? this.status,
      media: media ?? this.media,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      currentPage: currentPage ?? this.currentPage,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, mediaLength: ${media.length}, statusCode: $statusCode, message: $message, currentPage: $currentPage, MediaType: $mediaType}''';
  }
}
