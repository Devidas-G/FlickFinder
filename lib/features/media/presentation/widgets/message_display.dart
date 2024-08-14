import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final int code;
  final VoidCallback onRetry;

  const MessageDisplay({
    Key? key,
    required this.message,
    required this.code,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(
            height: 20,
          ),
          Text(code.toString()),
          ElevatedButton(onPressed: onRetry, child: Text("Retry"))
        ],
      ),
    );
  }
}
