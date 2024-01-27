import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../../core/common/api_config.dart';
import '../../domain/entities/media_entity.dart';

class MediaCard extends StatelessWidget {
  final MediaEntity media;
  const MediaCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      //semanticContainer: true,
      //clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              // Replace 'imagePath' with the actual property name for the image URL
              imageUrl: ApiConfig.imgHost + media.posterPath,
              fit: BoxFit.cover,
              placeholder: (context, url) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  media.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(media.releaseDate),
                //Text(movie.popularity.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
