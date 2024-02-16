import 'package:flutter/material.dart';

class FilterTile extends StatelessWidget {
  final String title;
  final Widget child;

  const FilterTile({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      tilePadding: EdgeInsets.zero,
      title: Text(title),
      children: [
        child,
      ],
    );
  }
}
