import 'package:flickfinder/core/utils/enum.dart';
import 'package:flutter/material.dart';

class SortTypeList extends StatelessWidget {
  final List<String> sortTypes;
  final ValueChanged<String> onChanged;
  final String selectedMediaType;
  const SortTypeList(
      {super.key,
      required this.sortTypes,
      required this.onChanged,
      required this.selectedMediaType});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: ToggleButtons(
          renderBorder: false,
          isSelected: List.generate(
            sortTypes.length,
            (index) => selectedMediaType == sortTypes[index],
          ),
          onPressed: (index) {
            onChanged(sortTypes[index]);
          },
          // borderRadius: BorderRadius.circular(8),
          selectedColor: Colors.white,
          fillColor: Theme.of(context).primaryColor,
          color: Colors.grey.shade700,
          borderColor: Colors.grey.shade400,
          selectedBorderColor: Theme.of(context).primaryColor,
          splashColor: Colors.blue.withOpacity(0.2),
          children: List.generate(
            sortTypes.length,
            (index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  sortTypes[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
