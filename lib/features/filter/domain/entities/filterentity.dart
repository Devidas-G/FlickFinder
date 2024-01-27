import 'package:equatable/equatable.dart';

class FilterEntity extends Equatable {
  final String title;

  const FilterEntity({required this.title});
  @override
  List<Object?> get props => [
        title,
      ];
}
