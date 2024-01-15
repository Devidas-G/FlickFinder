import 'package:flickfinder/features/movie/domain/entities/movie_entity.dart';
import 'package:flutter/material.dart';

class MoviesProvider with ChangeNotifier {
  List<MovieEntity> _moviesList = [];

  void addAllMovies(List<MovieEntity> newMoviesList) {
    if (newMoviesList.isNotEmpty) {
      moviesPage = moviesPage + 1;
    }
    _moviesList.addAll(newMoviesList);
    notifyListeners();
  }

  List<MovieEntity> get moviesList => _moviesList;

  int _moviesPage = 1;
  set moviesPage(int newMoviesPage) {
    _moviesPage = newMoviesPage;
    notifyListeners();
  }

  int get moviesPage => _moviesPage;
}
