part of 'media_bloc.dart';

sealed class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object> get props => [];
}

class GetMediaWithParamsEvent extends MediaEvent {
  final GetFilteredMediaParams getFilteredMediaParams;
  const GetMediaWithParamsEvent(this.getFilteredMediaParams);

  @override
  List<Object> get props => [getFilteredMediaParams];
}

class GetMoreMediaEvent extends MediaEvent {
  const GetMoreMediaEvent();
  @override
  List<Object> get props => [];
}
