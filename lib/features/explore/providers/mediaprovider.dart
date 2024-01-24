import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/explore/domain/entities/media_entity.dart';
import 'package:flutter/material.dart';

class MoviesProvider with ChangeNotifier {
  //! Movies list
  List<MediaEntity> _moviesList = [];

  void addAllMovies(List<MediaEntity> newMoviesList) {
    _moviesList.addAll(newMoviesList);
    notifyListeners();
  }

  set moviesList(List<MediaEntity> newMoviesList) {
    _moviesList = newMoviesList;
    notifyListeners();
  }

  List<MediaEntity> get moviesList => _moviesList;

  //! Filter
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
