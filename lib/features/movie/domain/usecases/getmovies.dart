import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/movie/domain/entities/movie_entity.dart';
import 'package:flickfinder/features/movie/domain/repositories/movie_repo.dart';

class GetMovies implements UseCase<List<MovieEntity>, GetMoviesParams> {
  final MovieRepo repository;

  GetMovies(this.repository);

  @override
  ResultFuture<List<MovieEntity>> call(GetMoviesParams params) async {
    return await repository.getMovies(params.page, params.genreId);
  }
}

class GetMoviesParams {
  final int page;
  final int genreId;
  GetMoviesParams(this.page, this.genreId);
}
