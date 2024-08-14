import 'package:flickfinder/core/utils/enum.dart';
import 'package:flutter/material.dart';

class MediaTypeList extends StatefulWidget {
  final List<MediaType> mediaType;
  final ValueChanged<MediaType> onChanged;
  final MediaType selectedMediaType;
  const MediaTypeList(
      {super.key,
      required this.mediaType,
      required this.onChanged,
      required this.selectedMediaType});

  @override
  State<MediaTypeList> createState() => _MediaTypeListState();
}

class _MediaTypeListState extends State<MediaTypeList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: ListView.builder(
          itemCount: widget.mediaType.length,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            MediaType type = widget.mediaType[index];
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextButton(
                onPressed: () {
                  widget.onChanged(type);
                },
                style: TextButton.styleFrom(
                  // padding: EdgeInsets.all(5),
                  backgroundColor: widget.selectedMediaType == type
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade800)),
                ),
                child: Text(type.name),
              ),
            );
          },
        ),
      ),
    );
  }
}
