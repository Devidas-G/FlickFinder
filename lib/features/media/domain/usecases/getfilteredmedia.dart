import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/filter/domain/entities/genreentity.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/repositories/media_repo.dart';

class GetFilteredMedia
    implements UseCase<List<MediaEntity>, GetFilteredMediaParams> {
  final MediaRepo repository;

  GetFilteredMedia(this.repository);

  @override
  ResultFuture<List<MediaEntity>> call(GetFilteredMediaParams params) async {
    return await repository.getFilteredMedia(params);
  }
}

class GetFilteredMediaParams {
  final int? page;
  final MediaType? mediaType;
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
  const GetFilteredMediaParams({
    this.page = 0,
    this.mediaType = MediaType.Movies,
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

  GetFilteredMediaParams copyWith({
    int? page,
    MediaType? mediaType,
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
    return GetFilteredMediaParams(
      page: page ?? this.page,
      mediaType: mediaType ?? this.mediaType,
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

  // Method to convert the class to a map
  Map<String, dynamic> toMap({List<String>? excludeKeys}) {
    Map<String, dynamic> map = {
      'page': page,
      'mediaType': mediaType,
      'genre': genre,
      'primaryReleaseDateGTE': primaryReleaseDateGTE,
      'primaryReleaseDateLTE': primaryReleaseDateLTE,
      'voteAverageGTE': voteAverageGTE,
      'language': language,
      'certificationCountry': certificationCountry,
      'certification': certification,
      'castId': castId,
      'region': region,
      'year': year,
    };

    // Remove keys specified in excludeKeys
    excludeKeys?.forEach((key) => map.remove(key));

    return map;
  }

  // Factory method to create an instance from a map
  factory GetFilteredMediaParams.fromMap(Map<String, dynamic> map) {
    return GetFilteredMediaParams(
      page: map['page'],
      mediaType: map['mediaType'],
      genre: map['genre'],
      primaryReleaseDateGTE: map['primaryReleaseDateGTE'],
      primaryReleaseDateLTE: map['primaryReleaseDateLTE'],
      voteAverageGTE: map['voteAverageGTE'],
      language: map['language'],
      certificationCountry: map['certificationCountry'],
      certification: map['certification'],
      castId: map['castId'],
      region: map['region'],
      year: map['year'],
    );
  }
}
