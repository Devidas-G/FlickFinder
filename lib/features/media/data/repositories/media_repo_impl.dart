import 'package:dartz/dartz.dart';
import 'package:flickfinder/core/errors/exception.dart';
import 'package:flickfinder/core/platform/network_info.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/media/data/datasources/media_remote_datasource.dart';
import 'package:flickfinder/features/media/data/models/movie_model.dart';
import 'package:flickfinder/features/media/data/models/tvshow_model.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/repositories/media_repo.dart';
import 'package:flickfinder/features/media/domain/usecases/getmedia.dart';

import '../../../../core/errors/failure.dart';

typedef Future<List<MovieModel>> _MovieDataSource();
typedef Future<List<TvShowModel>> _TvShowDataSource();

class MediaRepoImpl implements MediaRepo {
  final MediaRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  MediaRepoImpl({required this.remoteDatasource, required this.networkInfo});

  @override
  ResultFuture<List<MediaEntity>> getMedia(GetMediaParams params) async {
    if (params.mediaType == MediaType.Movies) {
      return await _getMovie(() => remoteDatasource.getMovies(params));
    } else {
      return await _getTvShow(() => remoteDatasource.getTvShows(params));
    }
  }

  ResultFuture<List<MediaEntity>> _getMovie(
      _MovieDataSource _movieDataSource) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteresult = await _movieDataSource();
        return Right(remoteresult);
      } on ApiException catch (e) {
        return Left(ApiFailure(e.statuscode, e.message));
      }
    } else {
      return const Left(NetworkFailure(1, "NO Internet"));
    }
  }

  ResultFuture<List<MediaEntity>> _getTvShow(
      _TvShowDataSource _tvShowDataSource) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteresult = await _tvShowDataSource();
        return Right(remoteresult);
      } on ApiException catch (e) {
        return Left(ApiFailure(e.statuscode, e.message));
      }
    } else {
      return const Left(NetworkFailure(1, "NO Internet"));
    }
  }

  @override
  ResultFuture<List<MediaEntity>> getTrending() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteresult = await remoteDatasource.getTrending();
        return Right(remoteresult);
      } on ApiException catch (e) {
        return Left(ApiFailure(e.statuscode, e.message));
      }
    } else {
      return const Left(NetworkFailure(1, "NO Internet"));
    }
  }
}
