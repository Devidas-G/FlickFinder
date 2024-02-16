import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../filter/presentation/widgets/loading_widget.dart';
import '../../../filter/presentation/widgets/message_display.dart';
import '../../domain/entities/media_entity.dart';
import '../bloc/media_bloc.dart';
import '../widgets/media_card.dart';

class MediaBuilder extends StatefulWidget {
  MediaBuilder({super.key});

  @override
  State<MediaBuilder> createState() => _MediaBuilderState();
}

class _MediaBuilderState extends State<MediaBuilder> {
  final ScrollController _scrollController = ScrollController();

  final PagingController<int, MediaEntity> _pagingController =
      PagingController(firstPageKey: 0);

  late final MediaBloc mediaBloc;

  @override
  void initState() {
    super.initState();
    mediaBloc = context.read<MediaBloc>();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      final GetFilteredMediaParams getFilteredMediaParams =
          mediaBloc.state.getFilteredMediaParams;
      mediaBloc.add(GetMoreMediaEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<MediaBloc, MediaState>(
        builder: (BuildContext context, MediaState state) {
          if (state.status == MediaStatus.initial) {
            return const LoadingWidget(
              message: "Initializing",
            );
          } else {
            _pagingController.itemList = state.media;
            return PagedGridView<int, MediaEntity>(
              cacheExtent: 9999,
              showNewPageProgressIndicatorAsGridChild: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing:
                      1, // Adjust spacing between grid items horizontally
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.6),
              builderDelegate: PagedChildBuilderDelegate<MediaEntity>(
                itemBuilder: (context, media, index) {
                  return MediaCard(media: media);
                },
                noItemsFoundIndicatorBuilder: (context) {
                  switch (state.status) {
                    case MediaStatus.loading:
                      return const LoadingWidget(
                        message: "Loading",
                      );
                    case MediaStatus.error:
                      return MessageDisplay(
                        message: state.message,
                        code: state.statusCode,
                      );
                    case MediaStatus.loaded:
                      if (state.media.isEmpty) {
                        return const Center(child: Text('no more media'));
                      } else {
                        return Icon(Icons.tv);
                      }
                    default:
                      return const MessageDisplay(
                        message: "something went wrong",
                        code: 0,
                      );
                  }
                },
                newPageProgressIndicatorBuilder: (context) {
                  switch (state.status) {
                    case MediaStatus.loading:
                      return const LoadingWidget(
                        message: "Loading",
                      );
                    case MediaStatus.error:
                      return MessageDisplay(
                        message: state.message,
                        code: state.statusCode,
                      );
                    case MediaStatus.loaded:
                      if (state.media.isEmpty) {
                        return const Center(child: Text('no more media'));
                      } else {
                        return Icon(Icons.tv);
                      }
                    default:
                      return const MessageDisplay(
                        message: "something went wrong",
                        code: 0,
                      );
                  }
                },
              ),
              pagingController: _pagingController,
              scrollController: _scrollController,
            );
          }
        },
      ),
    );
  }
}
