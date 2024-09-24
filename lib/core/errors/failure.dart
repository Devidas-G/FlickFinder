import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.statusCode, this.message);

  final int? statusCode;
  final String message;

  @override
  List<Object> get props => [statusCode!, message];
}

class ApiFailure extends Failure {
  const ApiFailure(super.statusCode, super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.statusCode, super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.statusCode, super.message);
}
