import 'package:flutter/material.dart';

import '../../domain/entities/media_entity.dart';
import 'widgets.dart';

class MediaGrid extends StatelessWidget {
  final List<MediaEntity> media;
  final ValueChanged<MediaEntity> onTap;
  final ScrollController scrollController;
  const MediaGrid(
      {super.key,
      required this.media,
      required this.onTap,
      required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount: media.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns in the grid
              crossAxisSpacing: 1, // Spacing between columns
              mainAxisSpacing: 1, // Spacing between rows
              childAspectRatio: 0.6, // Aspect ratio for each card
            ),
            itemBuilder: (context, index) {
              MediaEntity mediaEntity = media[index];
              return MediaCard(
                media: mediaEntity,
              );
            }));
  }
}


//               _pagingController.itemList = state.media;
//               return PagedGridView<int, MediaEntity>(
//                 shrinkWrap: true,
//                 cacheExtent: 9999,
//                 showNewPageProgressIndicatorAsGridChild: false,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing:
//                         1, // Adjust spacing between grid items horizontally
//                     mainAxisSpacing: 1,
//                     childAspectRatio: 0.6),
//                 builderDelegate: PagedChildBuilderDelegate<MediaEntity>(
//                   itemBuilder: (context, media, index) {
//                     return MediaCard(media: media);
//                   },
//                   noItemsFoundIndicatorBuilder: (context) {
//                     switch (state.status) {
//                       case MediaStatus.loading:
//                         return const LoadingWidget(
//                           message: "Loading",
//                         );
//                       case MediaStatus.error:
//                         return MessageDisplay(
//                           message: state.message,
//                           code: state.statusCode,
//                         );
//                       case MediaStatus.loaded:
//                         if (state.media.isEmpty) {
//                           return const Center(child: Text('no more media'));
//                         } else {
//                           return Icon(Icons.tv);
//                         }
//                       default:
//                         return const MessageDisplay(
//                           message: "something went wrong",
//                           code: 0,
//                         );
//                     }
//                   },
//                 ),
//                 pagingController: _pagingController,
//                 scrollController: _scrollController,
//               );