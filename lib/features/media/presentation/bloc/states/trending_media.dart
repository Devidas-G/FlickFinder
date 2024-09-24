import 'package:equatable/equatable.dart';
import '../../../../../core/utils/enum.dart';
import '../../../domain/entities/media_entity.dart';

abstract class TrendingMediaState extends Equatable {
  const TrendingMediaState();

  @override
  List<Object?> get props => [];
}

class TrendingMediaInitial extends TrendingMediaState {
  const TrendingMediaInitial();
}

class TrendingMediaLoading extends TrendingMediaState {
  const TrendingMediaLoading();
  @override
  List<Object?> get props => [];
}

class TrendingMediaLoaded extends TrendingMediaState {
  final List<MediaEntity> media;
  const TrendingMediaLoaded(this.media);

  @override
  List<Object?> get props => [media];
}

class TrendingMediaError extends TrendingMediaState {
  final String error;

  const TrendingMediaError(this.error);

  @override
  List<Object?> get props => [error];
}
