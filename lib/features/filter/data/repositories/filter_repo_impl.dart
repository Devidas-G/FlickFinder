import 'package:dartz/dartz.dart';
import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/core/utils/typedef.dart';
import 'package:flickfinder/features/filter/data/datasources/filter_local_datasource.dart';
import 'package:flickfinder/features/filter/data/datasources/filter_remote_datasource.dart';
import 'package:flickfinder/features/filter/data/models/genre_model.dart';
import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';
import 'package:flickfinder/features/filter/domain/entities/genreentity.dart';
import 'package:flickfinder/features/filter/domain/repositories/filterrepo.dart';
import 'package:flickfinder/features/filter/presentation/bloc/filter_bloc.dart';
import 'package:flickfinder/features/filter/presentation/widgets/selectiongrid.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/platform/network_info.dart';
import '../../../media/domain/usecases/getfilteredmedia.dart';

class FilterRepoImpl implements FilterRepo {
  final FilterLocalDatasource localDatasource;
  final FilterRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  FilterRepoImpl(
      {required this.localDatasource,
      required this.remoteDatasource,
      required this.networkInfo});
  @override
  ResultFuture<List<FilterEntity>> getFilterOptions(
      GetFilteredMediaParams params, FilterBloc filterBloc) async {
    List<GenreEntity> genreEntitys = [];
    if (await networkInfo.isConnected) {
      try {
        final remoteresult =
            await remoteDatasource.getGenre(filterBloc.state.mediaType);
        genreEntitys = remoteresult;
      } on ApiException catch (e) {
        return Left(ApiFailure(e.statuscode));
      }
    } else {
      return const Left(NetworkFailure(1));
    }

    List<GenreEntity>? selectedGenreEntitys =
        filterBloc.state.newFilterParams.genre;
    List<FilterEntity> filterlist = [
      FilterEntity(
        title: "Genre",
        widget: SelectionGrid(
          items: genreEntitys,
          filterBloc: filterBloc,
          selectedItems: selectedGenreEntitys,
        ),
      )
    ];
    return Right(filterlist);
  }
}
