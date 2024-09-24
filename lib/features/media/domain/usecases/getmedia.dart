import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
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
  final String? sortType;
  final int? year;
  const GetMediaParams({
    this.page = 0,
    required this.mediaType,
    required this.sortType,
    this.year,
  });

  GetMediaParams copyWith({
    int? page,
    MediaType? mediaType,
    String? sortType,
    int? year,
  }) {
    return GetMediaParams(
      page: page ?? this.page,
      mediaType: mediaType ?? this.mediaType,
      sortType: sortType ?? this.sortType,
      year: year ?? this.year,
    );
  }

  @override
  String toString() {
    return '''FilterParams { 
      page: $page,
      mediaType: $mediaType,
      category: $sortType,
      year: $year,
      }''';
  }

  int getTotalNonNullCount() {
    int totalNonNullCount = 0;
    if (year != null) totalNonNullCount++;
    return totalNonNullCount;
  }
}
