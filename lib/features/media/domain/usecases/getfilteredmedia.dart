import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/repositories/media_repo.dart';

class GetFilteredMedia
    implements UseCase<List<MediaEntity>, GetFilteredMediaParams> {
  final MediaRepo repository;

  GetFilteredMedia(this.repository);

  @override
  ResultFuture<List<MediaEntity>> call(GetFilteredMediaParams params) async {
    return await repository.getFilteredMedia(
        params.mediaType,
        params.page,
        params.genre,
        params.primaryReleaseDateGTE,
        params.primaryReleaseDateLTE,
        params.voteAverageGTE,
        params.language,
        params.certificationCountry,
        params.certification,
        params.castId,
        params.region,
        params.year);
  }
}

class GetFilteredMediaParams {
  final int page;
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
  const GetFilteredMediaParams({
    this.page = 0,
    this.mediaType = MediaType.Movies,
    this.genre = 0,
    this.primaryReleaseDateGTE = "",
    this.primaryReleaseDateLTE = "",
    this.voteAverageGTE = 0.0,
    this.language = "",
    this.certificationCountry = "",
    this.certification = "",
    this.castId = 0,
    this.region = "",
    this.year = 0,
  });
}
