import 'package:flickfinder/features/explore/data/datasources/movie_local_datasource.dart';
import 'package:flickfinder/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:flickfinder/features/explore/data/repositories/media_repo_impl.dart';
import 'package:flickfinder/features/explore/domain/usecases/getfilteredmovies.dart';
import 'package:flickfinder/features/explore/domain/usecases/getmedia.dart';
import 'package:flickfinder/features/explore/presentation/bloc/movie_bloc.dart';
import 'package:flickfinder/features/filter/presentation/bloc/filter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/platform/network_info.dart';
import 'features/explore/domain/repositories/media_repo.dart';

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
  sl.registerFactory(() => MovieBloc(getMedia: sl(), getFilteredMovies: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetMedia(sl()));
  sl.registerLazySingleton(() => GetFilteredMovies(sl()));

  // Repository
  sl.registerLazySingleton<MediaRepo>(() => MediaRepoImpl(
      localDatasource: sl(), remoteDatasource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<MovieRemoteDatasource>(
      () => MovieRemoteDatasourceImpl(client: sl()));
  sl.registerLazySingleton<MovieLocalDatasource>(
      () => MovieLocalDatasourceImpl(sharedPreferences: sl()));

  //! Features - Filter
  // Bloc
  sl.registerFactory(() => FilterBloc());

  // Use cases

  // Repository

  // Data sources
}
