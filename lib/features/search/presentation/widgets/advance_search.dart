import 'package:flutter/material.dart';

class AdvanceSearch extends StatelessWidget {
  final VoidCallback onClear;
  final VoidCallback onApply;
  const AdvanceSearch(
      {super.key, required this.onClear, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      horizontalTitleGap: 0,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      child: ExpansionTile(
        dense: true,
        minTileHeight: 0,
        title: Text("Advance Search"),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                  onPressed: onClear,
                  child: Text("Clear"),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 5)),
                  onPressed: onApply,
                  child: Text("Apply"),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
