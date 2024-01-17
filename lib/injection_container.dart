import 'package:flickfinder/features/movie/data/datasources/movie_local_datasource.dart';
import 'package:flickfinder/features/movie/data/datasources/movie_remote_datasource.dart';
import 'package:flickfinder/features/movie/data/repositories/movie_repo_impl.dart';
import 'package:flickfinder/features/movie/domain/usecases/getfilteredmovies.dart';
import 'package:flickfinder/features/movie/domain/usecases/getmovies.dart';
import 'package:flickfinder/features/movie/presentation/bloc/movie_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'core/platform/network_info.dart';
import 'features/movie/domain/repositories/movie_repo.dart';

final GetIt sl = GetIt.instance;
Future<void> init() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  //! Features - Movie
  // Bloc
  sl.registerFactory(() => MovieBloc(getMovies: sl(), getFilteredMovies: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerLazySingleton(() => GetFilteredMovies(sl()));

  // Repository
  sl.registerLazySingleton<MovieRepo>(() => MovieRepoImpl(
      localDatasource: sl(), remoteDatasource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<MovieRemoteDatasource>(
      () => MovieRemoteDatasourceImpl(client: sl()));
  sl.registerLazySingleton<MovieLocalDatasource>(
      () => MovieLocalDatasourceImpl(sharedPreferences: sl()));
}
