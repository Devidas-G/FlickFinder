import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';

class FilterModel extends FilterEntity {
  const FilterModel({required super.title});

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(title: json[''] ?? '');
  }
}
