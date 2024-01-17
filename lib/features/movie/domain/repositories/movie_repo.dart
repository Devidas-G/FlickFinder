import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/movie/domain/entities/movie_entity.dart';

abstract class MovieRepo {
  ResultFuture<List<MovieEntity>> getMovies(int page);
  ResultFuture<List<MovieEntity>> getFilteredMovies(String url, int page);
}
