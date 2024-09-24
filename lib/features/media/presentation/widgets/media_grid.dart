import 'package:flutter/material.dart';

import '../../domain/entities/media_entity.dart';
import 'widgets.dart';

class MediaGrid extends StatelessWidget {
  final List<MediaEntity> media;
  final ValueChanged<MediaEntity> onTap;

  const MediaGrid({
    super.key,
    required this.media,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: media.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (size.width / (size.height * 0.28)).ceil(),
          childAspectRatio: size.width > size.height
              ? size.height / (size.width / 0.85)
              : size.width / (size.height / 0.94),
        ),
        itemBuilder: (context, index) {
          MediaEntity mediaEntity = media[index];
          return MediaCard(
            media: mediaEntity,
          );
        });
  }
}
