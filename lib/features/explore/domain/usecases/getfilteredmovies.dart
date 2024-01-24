import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/explore/domain/entities/media_entity.dart';
import 'package:flickfinder/features/explore/domain/repositories/media_repo.dart';

class GetFilteredMovies
    implements UseCase<List<MediaEntity>, GetFilteredMoviesParams> {
  final MediaRepo repository;

  GetFilteredMovies(this.repository);

  @override
  ResultFuture<List<MediaEntity>> call(GetFilteredMoviesParams params) async {
    return await repository.getFilteredMovies(params.url, params.page);
  }
}

class GetFilteredMoviesParams {
  final int page;
  final String url;
  GetFilteredMoviesParams(this.page, this.url);
}
