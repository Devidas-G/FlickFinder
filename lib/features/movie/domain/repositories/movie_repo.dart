import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/movie/domain/entities/movie.dart';

abstract class MovieRepo {
  ResultFuture<List<Movie>> getPopularMovies();
}
