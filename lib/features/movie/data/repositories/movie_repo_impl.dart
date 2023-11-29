import 'package:dartz/dartz.dart';
import 'package:flickfinder/core/errors/exception.dart';
import 'package:flickfinder/core/platform/network_info.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/movie/data/datasources/movie_local_datasource.dart';
import 'package:flickfinder/features/movie/data/datasources/movie_remote_datasource.dart';
import 'package:flickfinder/features/movie/domain/entities/movie.dart';
import 'package:flickfinder/features/movie/domain/repositories/movie_repo.dart';

import '../../../../core/errors/failure.dart';

class MovieRepoImpl implements MovieRepo {
  final MovieLocalDatasource localDatasource;
  final MovieRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  MovieRepoImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});

  @override
  ResultFuture<List<Movie>> getPopularMovies(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteresult = await remoteDatasource.getPopularMovies(page);
        try {
          await localDatasource.cachePopularMovies(movies: remoteresult);
        } on CacheException catch (e) {
          return Left(CacheFailure(message: "${e.message}", statusCode: 1));
        }
        return Right(remoteresult);
      } on ApiException catch (e) {
        return Left(ApiFailure(message: e.message, statusCode: e.statuscode));
      }
    } else if (page == 1) {
      try {
        final localresult = await localDatasource.getLastPopularMovies();
        return Right(localresult);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: "${e.message}", statusCode: 1));
      }
    } else {
      return const Left(NetworkFailure(message: "No Internet", statusCode: 1));
    }
  }
}
