import 'package:equatable/equatable.dart';

class SearchEntity extends Equatable {
  final List<int> genreIds;

  const SearchEntity({required this.genreIds});
  @override
  List<Object?> get props => [genreIds];
}
