import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';

abstract class MediaRepo {
  ResultFuture<List<MediaEntity>> getMedia(int page, MediaType mediaType);
  ResultFuture<List<MediaEntity>> getFilteredMedia(
      MediaType mediaType,
      int page,
      int genre,
      String primaryReleaseDateGTE,
      String primaryReleaseDateLTE,
      double voteAverageGTE,
      String language,
      String certificationCountry,
      String certification,
      int castId,
      String region,
      int year);
}
