import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/movie/domain/repositories/movie_repo.dart';

class GetPopularMovies extends UseCaseWithoutParams {
  final MovieRepo _repo;

  GetPopularMovies(this._repo);

  @override
  ResultFuture call() async => _repo.getPopularMovies();
}
