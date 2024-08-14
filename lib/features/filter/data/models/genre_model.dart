import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';
import 'package:flickfinder/features/filter/domain/entities/genreentity.dart';

class GenreModel extends GenreEntity {
  GenreModel({required super.id, required super.name});
  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
