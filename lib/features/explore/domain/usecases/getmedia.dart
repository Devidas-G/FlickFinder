import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/explore/domain/entities/media_entity.dart';
import 'package:flickfinder/features/explore/domain/repositories/media_repo.dart';

import '../../../../core/utils/enum.dart';

class GetMedia implements UseCase<List<MediaEntity>, GetMediaParams> {
  final MediaRepo repository;

  GetMedia(this.repository);

  @override
  ResultFuture<List<MediaEntity>> call(GetMediaParams params) async {
    return await repository.getMedia(params.page, params.mediaType);
  }
}

class GetMediaParams {
  final int page;
  final MediaType mediaType;
  GetMediaParams(this.page, this.mediaType);
}
