import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/filter/domain/entities/genreentity.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/repositories/media_repo.dart';

class GetMedia implements UseCase<List<MediaEntity>, GetMediaParams> {
  final MediaRepo repository;

  GetMedia(this.repository);

  @override
  ResultFuture<List<MediaEntity>> call(GetMediaParams params) async {
    return await repository.getMedia(params);
  }
}

class GetMediaParams {
  final int? page;
  final MediaType mediaType;
  final String? category;
  final List<GenreEntity>? genre;
  final String? primaryReleaseDateGTE;
  final String? primaryReleaseDateLTE;
  final double? voteAverageGTE;
  final String? language;
  final String? certificationCountry;
  final String? certification;
  final int? castId;
  final String? region;
  final int? year;
  const GetMediaParams({
    this.page = 0,
    required this.mediaType,
    required this.category,
    this.genre,
    this.primaryReleaseDateGTE,
    this.primaryReleaseDateLTE,
    this.voteAverageGTE,
    this.language,
    this.certificationCountry,
    this.certification,
    this.castId,
    this.region,
    this.year,
  });

  GetMediaParams copyWith({
    int? page,
    MediaType? mediaType,
    String? category,
    List<GenreEntity>? genre,
    String? primaryReleaseDateGTE,
    String? primaryReleaseDateLTE,
    double? voteAverageGTE,
    String? language,
    String? certificationCountry,
    String? certification,
    int? castId,
    String? region,
    int? year,
  }) {
    return GetMediaParams(
      page: page ?? this.page,
      mediaType: mediaType ?? this.mediaType,
      category: category ?? this.category,
      genre: genre ?? this.genre,
      primaryReleaseDateGTE:
          primaryReleaseDateGTE ?? this.primaryReleaseDateGTE,
      primaryReleaseDateLTE:
          primaryReleaseDateLTE ?? this.primaryReleaseDateLTE,
      voteAverageGTE: voteAverageGTE ?? this.voteAverageGTE,
      language: language ?? this.language,
      certificationCountry: certificationCountry ?? this.certificationCountry,
      certification: certification ?? this.certification,
      castId: castId ?? this.castId,
      region: region ?? this.region,
      year: year ?? this.year,
    );
  }

  @override
  String toString() {
    return '''FilterParams { 
      page: $page,
      mediaType: $mediaType,
      category: $category,
      genre: $genre,
      primaryReleaseDateGTE: $primaryReleaseDateGTE,
      primaryReleaseDateLTE: $primaryReleaseDateLTE,
      voteAverageGTE: $voteAverageGTE,
      language: $language,
      certificationCountry: $certificationCountry,
      certification: $certification,
      castId: $castId,
      region: $region,
      year: $year,
      }''';
  }

  int getTotalNonNullCount() {
    int totalNonNullCount = 0;
    if (genre != null) totalNonNullCount++;
    if (primaryReleaseDateGTE != null) totalNonNullCount++;
    if (primaryReleaseDateLTE != null) totalNonNullCount++;
    if (voteAverageGTE != null) totalNonNullCount++;
    if (language != null) totalNonNullCount++;
    if (certificationCountry != null) totalNonNullCount++;
    if (certification != null) totalNonNullCount++;
    if (castId != null) totalNonNullCount++;
    if (region != null) totalNonNullCount++;
    if (year != null) totalNonNullCount++;
    return totalNonNullCount;
  }
}
