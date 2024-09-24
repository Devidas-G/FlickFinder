part of 'media_bloc.dart';

sealed class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object> get props => [];
}

class GetInitialMediaEvent extends MediaEvent {
  final GetMediaParams getMediaParams;
  const GetInitialMediaEvent(this.getMediaParams);

  @override
  List<Object> get props => [getMediaParams];
}

class GetMoreMediaEvent extends MediaEvent {
  const GetMoreMediaEvent();
  @override
  List<Object> get props => [];
}

class GetTrendingMediaEvent extends MediaEvent {
  const GetTrendingMediaEvent();
  @override
  List<Object> get props => [];
}
