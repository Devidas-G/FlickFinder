import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/api_config.dart';
import '../../domain/entities/media_entity.dart';

class MediaViewPage extends StatelessWidget {
  final MediaEntity media;
  const MediaViewPage({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  height: size.height * 0.3,
                  width: double.infinity,
                  imageUrl: ApiConfig.imgHost + media.backdropPath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white,
                    child: const Icon(
                      Icons.image,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                // TODO: Insert video player inside SafeArea
                // SafeArea(child: Text("data")),
              ],
            ),
            TabBar(
              tabs: [
                Tab(text: 'Overview'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Text('Overview')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
