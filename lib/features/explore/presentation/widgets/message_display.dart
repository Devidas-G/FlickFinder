import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final int code;

  const MessageDisplay({
    Key? key,
    required this.message,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          SizedBox(
            height: 20,
          ),
          Text(code.toString()),
        ],
      ),
    );
  }
}
