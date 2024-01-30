import 'package:dartz/dartz.dart';
import 'package:flickfinder/core/errors/exception.dart';
import 'package:flickfinder/core/platform/network_info.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/media/data/datasources/media_local_datasource.dart';
import 'package:flickfinder/features/media/data/datasources/media_remote_datasource.dart';
import 'package:flickfinder/features/media/data/models/movie_model.dart';
import 'package:flickfinder/features/media/data/models/tvshow_model.dart';
import 'package:flickfinder/features/media/domain/entities/media_entity.dart';
import 'package:flickfinder/features/media/domain/repositories/media_repo.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';

import '../../../../core/errors/failure.dart';

typedef Future<List<MovieModel>> _MovieDataSource();
typedef Future<List<TvShowModel>> _TvShowDataSource();

class MediaRepoImpl implements MediaRepo {
  final MediaLocalDatasource localDatasource;
  final MediaRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  MediaRepoImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});

  @override
  ResultFuture<List<MediaEntity>> getMedia(
      int page, MediaType mediaType) async {
    if (mediaType == MediaType.Movies) {
      return await _getMovie(() => remoteDatasource.getMovies(page));
    } else {
      return await _getTvShow(() => remoteDatasource.getTvShows(page));
    }
  }

  @override
  ResultFuture<List<MediaEntity>> getFilteredMedia(
      GetFilteredMediaParams params) async {
    if (params.mediaType == MediaType.Movies) {
      return await _getMovie(() => remoteDatasource.getFilteredMovies(params));
    } else {
      return await _getTvShow(
          () => remoteDatasource.getFilteredTvShows(params));
    }
  }

  ResultFuture<List<MediaEntity>> _getMovie(
      _MovieDataSource _movieDataSource) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteresult = await _movieDataSource();
        try {
          await localDatasource.cachePopularMovies(movies: remoteresult);
        } on CacheException catch (e) {
          return Left(CacheFailure(1));
        }
        return Right(remoteresult);
      } on ApiException catch (e) {
        return Left(ApiFailure(e.statuscode));
      }
    } else {
      try {
        final localresult = await localDatasource.getLastPopularMovies();
        return Right(localresult);
      } on CacheException catch (e) {
        return Left(CacheFailure(1));
      }
    }
  }

  ResultFuture<List<MediaEntity>> _getTvShow(
      _TvShowDataSource _tvShowDataSource) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteresult = await _tvShowDataSource();
        try {
          //await localDatasource.cachePopularMovies(movies: remoteresult);
        } on CacheException catch (e) {
          return Left(CacheFailure(1));
        }
        return Right(remoteresult);
      } on ApiException catch (e) {
        return Left(ApiFailure(e.statuscode));
      }
    } else {
      try {
        final localresult = await localDatasource.getLastPopularMovies();
        return Right(localresult);
      } on CacheException catch (e) {
        return Left(CacheFailure(1));
      }
    }
  }
}
