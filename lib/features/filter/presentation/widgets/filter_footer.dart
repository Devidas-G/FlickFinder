import 'package:flutter/material.dart';

Widget filterFooter(
    BuildContext context, Function() onApply, Function() onClear) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: TextButton(
              onPressed: () {
                onClear();
                Navigator.pop(context);
              },
              child: const Text("Clear All")),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              onApply();
              Navigator.pop(context);
            },
            child: Text("Apply"),
          ),
        ),
      ],
    ),
  );
}
