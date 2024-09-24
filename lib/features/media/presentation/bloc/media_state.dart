part of 'media_bloc.dart';

final class MediaState extends Equatable {
  const MediaState({
    this.mainMediaState = const MediaInitial(),
    this.mainMedia = const [],
    this.trendingMediaState = const TrendingMediaInitial(),
    this.subMedia = const {},
    this.getMediaParams =
        const GetMediaParams(mediaType: MediaType.Movies, sortType: ''),
  });
  final MainMediaState mainMediaState;
  final List<MediaEntity> mainMedia;
  final TrendingMediaState trendingMediaState;
  final GetMediaParams getMediaParams;
  final Map<String, List<MediaEntity>> subMedia;

  @override
  List<Object> get props => [
        mainMediaState,
        mainMedia,
        trendingMediaState,
        getMediaParams,
        subMedia,
      ];

  MediaState copyWith({
    MainMediaState? mainMediaState,
    List<MediaEntity>? mainMedia,
    TrendingMediaState? trendingMediaState,
    GetMediaParams? getFilteredMediaParams,
    Map<String, List<MediaEntity>>? subMedia,
  }) {
    return MediaState(
        mainMediaState: mainMediaState ?? this.mainMediaState,
        mainMedia: mainMedia ?? this.mainMedia,
        trendingMediaState: trendingMediaState ?? this.trendingMediaState,
        getMediaParams: getFilteredMediaParams ?? this.getMediaParams,
        subMedia: subMedia ?? this.subMedia);
  }

  @override
  String toString() {
    return '''PostState { 
      MainMediaState: $mainMediaState,
      mainMedia: $mainMedia,
      TrendingMedia: $trendingMediaState,
      FilterParams: $getMediaParams,
      subMedia: $subMedia,
      }''';
  }
}
