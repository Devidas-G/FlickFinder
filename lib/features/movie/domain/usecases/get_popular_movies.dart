import 'package:equatable/equatable.dart';
import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/movie/domain/entities/movie.dart';
import 'package:flickfinder/features/movie/domain/repositories/movie_repo.dart';

class GetPopularMovies extends UseCaseWithParams<void, GetPopularMoviesParams> {
  final MovieRepo _repo;

  GetPopularMovies(this._repo);

  @override
  ResultFuture<List<Movie>> call(GetPopularMoviesParams params) async =>
      _repo.getPopularMovies(params.page);
}

class GetPopularMoviesParams extends Equatable {
  final int page;

  GetPopularMoviesParams({required this.page});
  @override
  List<Object?> get props => [page];
}
