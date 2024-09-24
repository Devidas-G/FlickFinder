import 'package:flickfinder/core/usecase/usecase.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import '../entities/media_entity.dart';
import '../repositories/media_repo.dart';

class GetTrending implements UseCaseWithNoParams<List<MediaEntity>> {
  final MediaRepo repository;

  GetTrending(this.repository);

  @override
  ResultFuture<List<MediaEntity>> call() async {
    return await repository.getTrending();
  }
}
