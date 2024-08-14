import 'package:flutter/material.dart';

class CheckItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function()? onPressed;
  const CheckItem(
      {super.key,
      required this.text,
      required this.isSelected,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? Theme.of(context).primaryColor : Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        onPressed: onPressed,
        child: Text(text));
  }
}
