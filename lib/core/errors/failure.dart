import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.statusCode);

  final int statusCode;

  @override
  List<Object> get props => [statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure(super.statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure(super.statusCode);
}
