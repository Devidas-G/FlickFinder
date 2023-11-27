import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker internetConnectionChecker;
  final Connectivity connectivity;
  NetworkInfoImpl({
    required this.internetConnectionChecker,
    required this.connectivity,
  });
  @override
  Future<bool> get isConnected async {
    ConnectivityResult connectivityResult =
        await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      bool hasConnection = await internetConnectionChecker.hasConnection;
      return hasConnection;
    } else {
      return false;
    }
  }
}
