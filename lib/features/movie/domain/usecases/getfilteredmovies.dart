import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/movie/domain/entities/movie_entity.dart';
import 'package:flickfinder/features/movie/domain/repositories/movie_repo.dart';

class GetFilteredMovies
    implements UseCase<List<MovieEntity>, GetFilteredMoviesParams> {
  final MovieRepo repository;

  GetFilteredMovies(this.repository);

  @override
  ResultFuture<List<MovieEntity>> call(GetFilteredMoviesParams params) async {
    return await repository.getFilteredMovies(params.url, params.page);
  }
}

class GetFilteredMoviesParams {
  final int page;
  final String url;
  GetFilteredMoviesParams(this.page, this.url);
}
