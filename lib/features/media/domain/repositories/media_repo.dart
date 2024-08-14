import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';

abstract class MediaRepo {
  ResultFuture<List<MediaEntity>> getMedia(GetMediaParams getMediaParams);
}
