import 'package:flickfinder/features/media/data/datasources/media_local_datasource.dart';
import 'package:flickfinder/features/media/data/datasources/media_remote_datasource.dart';
import 'package:flickfinder/features/media/data/repositories/media_repo_impl.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:flickfinder/features/media/domain/usecases/getmedia.dart';
import 'package:flickfinder/features/media/presentation/bloc/media_bloc.dart';
import 'package:flickfinder/features/filter/data/datasources/filter_local_datasource.dart';
import 'package:flickfinder/features/filter/data/datasources/filter_remote_datasource.dart';
import 'package:flickfinder/features/filter/data/repositories/filter_repo_impl.dart';
import 'package:flickfinder/features/filter/domain/repositories/filterrepo.dart';
import 'package:flickfinder/features/filter/presentation/bloc/filter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/platform/network_info.dart';
import 'features/media/domain/repositories/media_repo.dart';

final GetIt sl = GetIt.instance;
Future<void> init() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //! Features - Media
  // Bloc
  sl.registerFactory(() => MediaBloc(getMedia: sl(), getFilteredMedia: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetMedia(sl()));
  sl.registerLazySingleton(() => GetFilteredMedia(sl()));

  // Repository
  sl.registerLazySingleton<MediaRepo>(() => MediaRepoImpl(
      localDatasource: sl(), remoteDatasource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<MediaRemoteDatasource>(
      () => MediaRemoteDatasourceImpl(client: sl()));
  sl.registerLazySingleton<MediaLocalDatasource>(
      () => MediaLocalDatasourceImpl(sharedPreferences: sl()));

  //! Features - Filter
  // Bloc
  sl.registerFactory(() => FilterBloc());

  // Use cases
  sl.registerLazySingleton(() => GetFilterOptions(sl()));

  // Repository
  sl.registerLazySingleton<FilterRepo>(() => FilterRepoImpl(
      localDatasource: sl(), remoteDatasource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<FilterRemoteDatasource>(
      () => FilterRemoteDatasourceImpl(client: sl()));
  sl.registerLazySingleton<FilterLocalDatasource>(
      () => FilterLocalDatasourceImpl(sharedPreferences: sl()));
}
