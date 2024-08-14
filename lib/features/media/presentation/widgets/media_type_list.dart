import 'package:flickfinder/core/utils/enum.dart';
import 'package:flutter/material.dart';

class MediaTypeList extends StatefulWidget {
  final List<String> mediaType;
  final ValueChanged<String?> onChanged;
  const MediaTypeList(
      {super.key, required this.mediaType, required this.onChanged});

  @override
  State<MediaTypeList> createState() => _MediaTypeListState();
}

class _MediaTypeListState extends State<MediaTypeList> {
  @override
  Widget build(BuildContext context) {
    String _selectedType = widget.mediaType.first;
    return Expanded(
      child: ListView.builder(
        itemCount: widget.mediaType.length,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          String type = widget.mediaType[index];
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton(
              onPressed: () {
                widget.onChanged(type);
                setState(() {
                  _selectedType = type;
                });
              },
              style: TextButton.styleFrom(
                // padding: EdgeInsets.all(5),
                backgroundColor: _selectedType == type
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.grey.shade800)),
              ),
              child: Text(type),
            ),
          );
        },
      ),
    );
  }
}
