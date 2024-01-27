part of 'media_bloc.dart';

sealed class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object> get props => [];
}

class GetMediaEvent extends MediaEvent {
  final MediaType mediaType;
  const GetMediaEvent(this.mediaType);

  @override
  List<Object> get props => [mediaType];
}

class GetFilteredMoviesEvent extends MediaEvent {
  final int page;
  final String url;
  const GetFilteredMoviesEvent(this.page, this.url);
  @override
  List<Object> get props => [page, url];
}
