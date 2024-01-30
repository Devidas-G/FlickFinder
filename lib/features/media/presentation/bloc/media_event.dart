part of 'media_bloc.dart';

sealed class MediaEvent extends Equatable {
  final MediaType mediaType;
  const MediaEvent(this.mediaType);

  @override
  List<Object> get props => [];
}

class GetMediaEvent extends MediaEvent {
  final MediaType mediaType;
  const GetMediaEvent(this.mediaType) : super(mediaType);

  @override
  List<Object> get props => [mediaType];
}

class GetMediaWithParamsEvent extends MediaEvent {
  final MediaType mediaType;
  final int genre;
  final String primaryReleaseDateGTE;
  final String primaryReleaseDateLTE;
  final double voteAverageGTE;
  final String language;
  final String certificationCountry;
  final String certification;
  final int castId;
  final String region;
  final int year;
  const GetMediaWithParamsEvent(
      this.mediaType,
      this.genre,
      this.primaryReleaseDateGTE,
      this.primaryReleaseDateLTE,
      this.voteAverageGTE,
      this.language,
      this.certificationCountry,
      this.certification,
      this.castId,
      this.region,
      this.year)
      : super(mediaType);
  @override
  List<Object> get props => [mediaType];
}

class GetFilterMediaEvent extends GetMediaWithParamsEvent {
  GetFilterMediaEvent(
      super.mediaType,
      super.genre,
      super.primaryReleaseDateGTE,
      super.primaryReleaseDateLTE,
      super.voteAverageGTE,
      super.language,
      super.certificationCountry,
      super.certification,
      super.castId,
      super.region,
      super.year);

  @override
  List<Object> get props => [mediaType];
}
