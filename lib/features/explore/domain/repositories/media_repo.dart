import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/explore/domain/entities/media_entity.dart';

abstract class MediaRepo {
  ResultFuture<List<MediaEntity>> getMedia(int page, MediaType mediaType);
  ResultFuture<List<MediaEntity>> getFilteredMovies(String url, int page);
}
