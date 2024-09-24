import 'package:flickfinder/core/utils/enum.dart';
import 'package:flutter/material.dart';

class HomeState with ChangeNotifier {
  int _currentindex = 0;
  set currentindex(int newpageindex) {
    _currentindex = newpageindex;
    notifyListeners();
  }

  int get currentindex => _currentindex;

  MediaType _currentMediaType = MediaType.Movies;
  set currentMediaType(MediaType newMediaType) {
    _currentMediaType = newMediaType;
    notifyListeners();
  }

  MediaType get currentMediaType => _currentMediaType;

  String _currentSortType = MoviesSortTypes.values.first.name;
  set currentSortType(String newSortType) {
    _currentSortType = newSortType;
    notifyListeners();
  }

  String get currentSortType => _currentSortType;
}
