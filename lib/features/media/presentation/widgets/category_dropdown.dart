import 'package:flutter/material.dart';

class CategoryDropdown extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String?> onChanged;
  const CategoryDropdown(
      {super.key, required this.categories, required this.onChanged});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('All'), // Initial hint text
      value: _selectedCategory,
      items: [
        DropdownMenuItem<String>(
          value: null, // Represents the "All" option
          child: Text('All'),
        ),
        ...widget.categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
      ],
      onChanged: (String? value) {
        setState(() {
          _selectedCategory = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
