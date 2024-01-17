import 'package:flickfinder/features/movie/domain/entities/movie_entity.dart';
import 'package:flutter/material.dart';

class MoviesProvider with ChangeNotifier {
  //! Movies list
  List<MovieEntity> _moviesList = [];

  void addAllMovies(List<MovieEntity> newMoviesList) {
    if (newMoviesList.isNotEmpty) {
      moviesPage = moviesPage + 1;
    }
    _moviesList.addAll(newMoviesList);
    notifyListeners();
  }

  set moviesList(List<MovieEntity> newMoviesList) {
    _moviesList = newMoviesList;
    notifyListeners();
  }

  List<MovieEntity> get moviesList => _moviesList;

  //! Movies pagingation
  int _moviesPage = 1;
  set moviesPage(int newMoviesPage) {
    _moviesPage = newMoviesPage;
    notifyListeners();
  }

  int get moviesPage => _moviesPage;

  //! Filter status
  bool _isFiltered = false;
  set isFiltered(bool newfiltered) {
    _isFiltered = newfiltered;
    notifyListeners();
  }

  bool get isFiltered => _isFiltered;

  String _filterurl = "";
  set filterUrl(String newUrl) {
    _filterurl = newUrl;
    notifyListeners();
  }

  String get filterUrl => _filterurl;
}
