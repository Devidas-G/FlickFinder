import 'package:flickfinder/features/search/domain/entities/search_entity.dart';

class SearchModel extends SearchEntity {
  const SearchModel({required super.genreIds});
  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(genreIds: List<int>.from(json['genre_ids'] ?? []));
  }
  Map<String, dynamic> toJson() {
    return {
      'genre_ids': genreIds,
    };
  }
}
