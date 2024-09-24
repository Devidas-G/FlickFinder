import 'package:equatable/equatable.dart';

import '../utils/typedef.dart';

abstract class UseCase<Type, Params> {
  ResultFuture<Type> call(Params params);
}

abstract class UseCaseWithNoParams<Type> {
  ResultFuture<Type> call();
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class UseCaseWithBloc<Type, FilterBloc> {
  ResultFuture<Type> call(FilterBloc filterBloc);
}
