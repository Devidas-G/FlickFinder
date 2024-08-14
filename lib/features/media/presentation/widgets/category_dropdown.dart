import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String?> onChanged;
  const CategoryDropdown(
      {super.key,
      required this.categories,
      required this.onChanged,
      required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(categories.first), // Initial hint text
      value: selectedCategory,
      items: [
        ...categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
      ],
      onChanged: (String? value) {
        onChanged(value);
      },
    );
  }
}
