import 'package:dartz/dartz.dart';
import 'package:flickfinder/features/movie/data/models/movie_model.dart';
import 'package:flickfinder/features/movie/domain/entities/movie.dart';
import 'package:flickfinder/features/movie/domain/repositories/movie_repo.dart';
import 'package:flickfinder/features/movie/domain/usecases/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepo extends Mock implements MovieRepo {}

void main() {
  late MockMovieRepo mockMovieRepo;
  late GetPopularMovies getPopularMovies;
  const movieModelList = [
    MovieModel(
        adult: false,
        backdropPath: "/xgGGinKRL8xeRkaAR9RMbtyk60y.jpg",
        genreIds: [16, 10751, 10402, 14, 35],
        id: 901362,
        originalLanguage: "en",
        originalTitle: "Trolls Band Together",
        overview:
            "When Branch’s brother, Floyd, is kidnapped for his musical talents by a pair of nefarious pop-star villains, Branch and Poppy embark on a harrowing and emotional journey to reunite the other brothers and rescue Floyd from a fate even worse than pop-culture obscurity.",
        popularity: 2553.085,
        posterPath: "/bkpPTZUdq31UGDovmszsg2CchiI.jpg",
        releaseDate: "2023-10-12",
        title: "Trolls Band Together",
        video: false,
        voteAverage: 7.25,
        voteCount: 160)
  ];
  List<Movie> movieList = movieModelList;
  final GetPopularMoviesParams getPopularMoviesParams =
      GetPopularMoviesParams(page: 1);
  setUp(() {
    mockMovieRepo = MockMovieRepo();
    getPopularMovies = GetPopularMovies(mockMovieRepo);
  });
  test('get list of popular movies ...', () async {
    //arrange
    when(() => mockMovieRepo.getPopularMovies(1))
        .thenAnswer((invocation) async => Right(movieModelList));
    //act
    final result = await getPopularMovies(getPopularMoviesParams);
    //assert
    expect(result, Right(movieList));
    verify(() => mockMovieRepo.getPopularMovies(1)).called(1);
    verifyNoMoreInteractions(mockMovieRepo);
  });
}
