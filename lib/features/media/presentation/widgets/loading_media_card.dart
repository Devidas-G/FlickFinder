import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingMediaCard extends StatelessWidget {
  const LoadingMediaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Column(children: [
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 20,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 5,
                    width: 10,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
