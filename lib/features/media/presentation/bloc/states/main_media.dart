import 'package:equatable/equatable.dart';
import '../../../../../core/utils/enum.dart';

abstract class MainMediaState extends Equatable {
  const MainMediaState();

  @override
  List<Object?> get props => [];
}

class MediaInitial extends MainMediaState {
  const MediaInitial();
}

class MediaLoading extends MainMediaState {
  final int page;
  final MediaType mediaType;
  const MediaLoading(this.page, this.mediaType);
  @override
  List<Object?> get props => [page, mediaType];
}

class MediaError extends MainMediaState {
  final String error;
  final int? code;
  final int page;
  final MediaType mediaType;

  const MediaError(this.error, this.page, this.mediaType, this.code);

  @override
  List<Object?> get props => [error, page, mediaType, code];
}

class MediaLoaded extends MainMediaState {
  final bool hasReachedMax;
  final int page;
  final MediaType mediaType;
  const MediaLoaded(this.hasReachedMax, this.page, this.mediaType);

  @override
  List<Object?> get props => [hasReachedMax, page, mediaType];
}
