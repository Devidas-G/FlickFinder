import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/platform/network_info.dart';

// Media Imports
import 'features/media/data/datasources/media_remote_datasource.dart';
import 'features/media/data/repositories/media_repo_impl.dart';
import 'features/media/presentation/bloc/media_bloc.dart';
import 'features/media/domain/repositories/media_repo.dart';
import 'features/media/domain/usecases/usecase.dart';

//Search Imports

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
  sl.registerFactory(() => MediaBloc(getMedia: sl(), getTrending: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetMedia(sl()));
  sl.registerLazySingleton(() => GetTrending(sl()));

  // Repository
  sl.registerLazySingleton<MediaRepo>(
      () => MediaRepoImpl(remoteDatasource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<MediaRemoteDatasource>(
      () => MediaRemoteDatasourceImpl());

  //! Features - Search
  // Bloc

  // Use cases

  // Repository

  // Data sources

  //! Features -
  // Bloc

  // Use cases

  // Repository

  // Data sources
}
